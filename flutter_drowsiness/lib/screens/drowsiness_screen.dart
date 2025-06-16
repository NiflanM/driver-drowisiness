import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class DrowsinessCameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const DrowsinessCameraScreen({Key? key, required this.cameras})
      : super(key: key);

  @override
  State<DrowsinessCameraScreen> createState() => _DrowsinessCameraScreenState();
}

class _DrowsinessCameraScreenState extends State<DrowsinessCameraScreen> {
  late CameraController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final frontCamera = widget.cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _controller.initialize();
      if (!mounted) return;
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Camera initialization error: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Bright background to light user's face
      body: SafeArea(
        child: _isInitialized
            ? Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: CameraPreview(_controller),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
