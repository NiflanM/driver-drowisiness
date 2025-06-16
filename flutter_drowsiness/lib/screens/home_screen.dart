// ignore_for_file: use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera_screen.dart';
import 'about_screen.dart';
import 'preview_camera.dart';
import 'faqs_screen.dart';

class HomeScreen extends StatelessWidget {
  final CameraDescription frontCamera;

  const HomeScreen({Key? key, required this.frontCamera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // AppBar
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 10, 35, 47),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(100),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 116, 99, 99).withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF64FFDA).withOpacity(0.1),
                      child: const Icon(
                        Icons.directions_car,
                        color: Color(0xFF64FFDA),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "SafeDrive",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          "Driver Safety System",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: const Color(0xFF8892B0).withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Start Detection Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SilentDetectionScreen(camera: frontCamera),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 30.0),
                textStyle: const TextStyle(fontSize: 18),
                minimumSize: const Size(300, 90),
                backgroundColor: Color.fromARGB(255, 10, 35, 47),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Start Detection",
                      style: TextStyle(
                        fontFamily: 'Roboto Condensed',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0),
                      child: Image.asset(
                        'assets/images/dr.jpg',
                        width: 128,
                        height: 90,
                        fit: BoxFit.fill,
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Preview Camera Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraScreen(camera: frontCamera),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 28.0),
                minimumSize: const Size(300, 90),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: Color.fromARGB(255, 10, 35, 47),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Preview Camera",
                      style: TextStyle(
                        fontFamily: 'Roboto Condensed',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Image.asset(
                        'assets/images/f.png',
                        width: 128,
                        height: 90,
                        fit: BoxFit.fill,
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // About Us Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 40.0),
                minimumSize: const Size(300, 90),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: Color.fromARGB(255, 10, 35, 47),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "About Us",
                      style: TextStyle(
                        fontFamily: 'Roboto Condensed',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 65.0),
                      child: Image.asset(
                        'assets/images/t12.png',
                        width: 128,
                        height: 90,
                        fit: BoxFit.fill,
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Support Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupportScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 40.0),
                minimumSize: const Size(300, 90),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: Color.fromARGB(255, 10, 35, 47),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Support",
                      style: TextStyle(
                        fontFamily: 'Roboto Condensed',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: Image.asset(
                        'assets/images/h.jpeg',
                        width: 125,
                        height: 90,
                        fit: BoxFit.fill,
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        height: 40,
        color: Color.fromARGB(255, 238, 236, 236),
        child: Padding(
          padding: EdgeInsets.only(top: 14, left: 5),
          child: Text(
            "Version 1.0.0",
            style: TextStyle(
              fontFamily: 'Jersey 15',
              fontSize: 12,
              color: Color.fromARGB(255, 71, 70, 70),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
