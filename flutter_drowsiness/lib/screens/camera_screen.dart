import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:light/light.dart';
import 'package:screen_brightness/screen_brightness.dart';

class DrowsinessApp extends StatelessWidget {
  final CameraDescription camera;

  const DrowsinessApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drowsiness Detector',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CameraScreen(camera: camera),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  bool _isDetecting = false;
  String _result = 'Results shown here';
  Timer? _timer;
  final AudioPlayer _alarmPlayer = AudioPlayer();
  bool _alarmOn = false;
  bool _isInitialized = false;

  Light? _lightSensor;
  StreamSubscription<int>? _lightSubscription;

// Auto brightness enabled by default
  bool _autoBrightnessEnabled = true;
  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _initializeCamera();
    _initializeLightSensor();
  }

  Future<void> _requestPermissions() async {
    await [Permission.camera, Permission.storage, Permission.sensors].request();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    try {
      await _controller.initialize();
      if (!mounted) return;
      await _increaseExposure();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Camera init error: $e');
    }
  }

  Future<void> _increaseExposure() async {
    try {
      if (!_controller.value.isInitialized) return;
      final maxOffset = await _controller.getMaxExposureOffset();
      final targetOffset = maxOffset.clamp(-2.0, 2.0);
      await _controller.setExposureOffset(targetOffset);
      print('Exposure set to $targetOffset');
    } catch (e) {
      print('Exposure adjustment error: $e');
    }
  }

  void _initializeLightSensor() {
    _lightSensor = Light();
    _lightSubscription =
        _lightSensor!.lightSensorStream.listen((luxValue) async {
      if (!_autoBrightnessEnabled) return;

      try {
        if (luxValue < 10) {
          // increases the brightness and exposure
          await ScreenBrightness().setScreenBrightness(0.8);

          if (_controller.value.isInitialized) {
            final maxExposure = await _controller.getMaxExposureOffset();
            final targetExposure = maxExposure.clamp(-2.0, 2.0);
            await _controller.setExposureOffset(targetExposure);
          }
        } else {
          // resets to normal brightness and exposure
          await ScreenBrightness().setScreenBrightness(0.2);

          if (_controller.value.isInitialized) {
            await _controller.setExposureOffset(0.0);
          }
        }
      } catch (e) {
        print("Error adjusting brightness or exposure: $e");
      }
    });
  }

  void _toggleAutoBrightness() async {
    setState(() {
      _autoBrightnessEnabled = !_autoBrightnessEnabled;
    });

    if (!_autoBrightnessEnabled) {
      // Reset brightness to default when disabling auto brightness
      try {
        await ScreenBrightness().setScreenBrightness(0.1);
        print("Auto brightness disabled, reset to 0.5");
      } catch (e) {
        print("Error resetting brightness: $e");
      }
    }
  }

  void _startMonitoring() {
    if (_isDetecting) return;
    setState(() {
      _isDetecting = true;
      _result = 'Monitoring started...';
    });
    _timer =
        Timer.periodic(const Duration(seconds: 2), (_) => _captureAndDetect());
  }

  void _stopMonitoring() {
    if (!_isDetecting) return;
    setState(() {
      _isDetecting = false;
      _result = 'Monitoring stopped.';
    });
    _timer?.cancel();
    _stopAlarm();
    _controller.setExposureOffset(0.0);
  }

  Future<void> _captureAndDetect() async {
    if (!_controller.value.isInitialized) return;

    try {
      final XFile image = await _controller.takePicture();
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      final url = Uri.parse('http://192.168.8.102:5000/detect');
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );

      if (res.statusCode != 200) {
        setState(() => _result = 'Server error: ${res.body}');
        return;
      }

      final data = jsonDecode(res.body);
      final bool drowsy = data['drowsy'] as bool;
      setState(() {
        _result = drowsy
            ? "Drowsy!\nEAR: ${data['ear']}\nMAR: ${data['mar']}"
            : "No Drowsiness Detected\nEAR: ${data['ear']}\nMAR: ${data['mar']}";
      });

      if (drowsy) {
        _playAlarm();
      } else {
        _stopAlarm();
      }
    } catch (e) {
      setState(() => _result = 'Error: $e');
    }
  }

  void _playAlarm() async {
    if (!_alarmOn) {
      await _alarmPlayer.play(AssetSource('alarm.mp3'));
      _alarmOn = true;
    }
  }

  void _stopAlarm() {
    if (_alarmOn) {
      _alarmPlayer.pause();
      _alarmOn = false;
    }
  }

  @override
  void dispose() {
    _lightSubscription?.cancel();
    _timer?.cancel();
    _controller.dispose();
    _alarmPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isInitialized
            ? Column(
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      width: 340,
                      height: 570,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: CameraPreview(_controller),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      _result,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Toggle button for auto brightness
                  ElevatedButton(
                    onPressed: _toggleAutoBrightness,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      backgroundColor:
                          _autoBrightnessEnabled ? Colors.green : Colors.red,
                    ),
                    child: Text(_autoBrightnessEnabled
                        ? 'Disable Auto Brightness'
                        : 'Enable Auto Brightness'),
                  ),

                  const SizedBox(height: 10),

                  // Start/Stop monitoring button
                  ElevatedButton(
                    onPressed:
                        _isDetecting ? _stopMonitoring : _startMonitoring,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                    ),
                    child: Text(
                        _isDetecting ? 'Stop Monitoring' : 'Start Monitoring'),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
