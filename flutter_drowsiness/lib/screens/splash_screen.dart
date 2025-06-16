import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drowsiness/main.dart';
import 'package:flutter_drowsiness/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final CameraDescription frontCamera;
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textSlide;
  late Animation<Color?> _bgGradient;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Simplified logo scale animation without TweenSequence
    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    // Logo fades in
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Text slides up
    _textSlide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOutBack),
      ),
    );

    // Background gradient transition
    _bgGradient = ColorTween(
      begin: const Color(0xFF0F2027), // Dark blue
      end: const Color(0xFF2C5364), // Lighter blue
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Subtle pulse effect with its own controller
    _pulse = Tween<double>(begin: 1, end: 1.03).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => HomeScreen(frontCamera: frontCamera),
          transitionsBuilder: (_, a, __, c) =>
              FadeTransition(opacity: a, child: c),
          transitionDuration: const Duration(milliseconds: 800),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: _bgGradient.value,
          body: Stack(
            children: [
              // Animated background elements
              _buildAnimatedBackground(isDark),

              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with scale and opacity animation
                    Transform.scale(
                      scale: _logoScale.value,
                      child: Opacity(
                        opacity: _logoOpacity.value,
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? Colors.black.withOpacity(0.3)
                                : Colors.white.withOpacity(0.2),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary
                                    .withOpacity(0.2 * _logoOpacity.value),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Transform.scale(
                            scale: _pulse.value,
                            child: Hero(
                              tag: 'app-logo',
                              child: Image.asset(
                                'assets/images/tst.png',
                                width: min(size.width * 0.45, 180),
                                height: min(size.width * 0.45, 180),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // App name with slide animation
                    Transform.translate(
                      offset: Offset(0, _textSlide.value),
                      child: Opacity(
                        opacity: _controller.value,
                        child: Column(
                          children: [
                            Text(
                              'DROWSINESS GUARD',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Stay Alert • Drive Safe',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white.withOpacity(0.8),
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Footer with version info
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: _controller.value,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'v1.0.0',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedBackground(bool isDark) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _SplashBackgroundPainter(
          progress: _controller.value,
          isDark: isDark,
        ),
      ),
    );
  }
}

class _SplashBackgroundPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _SplashBackgroundPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = max(size.width, size.height) * 0.8;

    // Ensure progress stays within bounds
    final clampedProgress = progress.clamp(0.0, 1.0);

    // Animated circles
    for (int i = 0; i < 3; i++) {
      final radius = maxRadius * (0.3 + (i * 0.2)) * clampedProgress;
      final opacity = 0.2 - (i * 0.05);

      final paint = Paint()
        ..color = (isDark ? Colors.blueGrey : Colors.white)
            .withOpacity(opacity * clampedProgress)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, radius, paint);
    }

    // Grid pattern
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.03 * clampedProgress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const gridSize = 50;
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SplashBackgroundPainter oldDelegate) {
    return progress != oldDelegate.progress || isDark != oldDelegate.isDark;
  }
}
