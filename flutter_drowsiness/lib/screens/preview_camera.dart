import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class SilentDetectionScreen extends StatefulWidget {
  final CameraDescription camera;

  const SilentDetectionScreen({Key? key, required this.camera})
      : super(key: key);

  @override
  State<SilentDetectionScreen> createState() => _SilentDetectionScreenState();
}

class _SilentDetectionScreenState extends State<SilentDetectionScreen> {
  late CameraController _controller;
  Timer? _timer;
  bool _isDetecting = false;
  bool _isInitialized = false;

  final AudioPlayer _alarmPlayer = AudioPlayer();
  bool _alarmOn = false;
  String _lastAlarmType = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _controller.initialize();
      setState(() {
        _isInitialized = true;
      });
      _startSilentMonitoring();
    } catch (e) {
      print("Camera initialization error: $e");
    }
  }

  void _startSilentMonitoring() {
    if (_isDetecting) return;

    _isDetecting = true;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Drowsiness Detection Started'),
        duration: Duration(seconds: 2),
      ),
    );

    _timer = Timer.periodic(Duration(seconds: 2), (_) => _captureAndDetect());
  }

  Future<void> _captureAndDetect() async {
    if (!_controller.value.isInitialized || _controller.value.isTakingPicture)
      return;

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

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final bool drowsy = data['drowsy'] ?? false;
        final bool faceDetected = !(data['message'] == 'No face detected');

        if (!faceDetected) {
          print("No face detected!");
          _playAlarm('noface');
        } else if (drowsy) {
          print("Drowsiness detected!");
          _playAlarm('drowsy');
        } else {
          _stopAlarm();
          print("Alert and face detected.");
        }
      } else {
        print("Server error: ${res.statusCode}");
      }
    } catch (e) {
      print("Detection error: $e");
    }
  }

  Future<void> _playAlarm(String type) async {
    if (_alarmOn && _lastAlarmType == type) return;

    await _alarmPlayer.stop();
    await _alarmPlayer.setReleaseMode(ReleaseMode.loop);

    if (type == 'drowsy') {
      await _alarmPlayer.play(AssetSource('alarm.mp3'));
    } else if (type == 'noface') {
      await _alarmPlayer.play(AssetSource('alarm_face.mp3'));
    }

    _alarmOn = true;
    _lastAlarmType = type;
  }

  void _stopAlarm() async {
    if (_alarmOn) {
      await _alarmPlayer.stop();
      _alarmOn = false;
      _lastAlarmType = '';
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _alarmPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Driver Drowsiness Detection"),
        backgroundColor: Color.fromARGB(255, 47, 114, 114),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isInitialized)
              CircularProgressIndicator()
            else
              SizedBox(height: 20),
            Text(
              "Running in background will be alerted if drowsiness is detected.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _stopAlarm();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: Size(275, 65),
                textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              child: Text("STOP"),
            ),
          ],
        ),
      ),
    );
  }
}
