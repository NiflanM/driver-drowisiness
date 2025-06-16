import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 146, 194, 194),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 440,
            height: 110,
            padding: const EdgeInsets.only(bottom: 10, top: 5),
            color: const Color.fromARGB(255, 146, 194, 194),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 05),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_circle_left_outlined,
                      color: Color.fromARGB(153, 0, 0, 0),
                      size: 35,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 3.5),
                const Padding(
                  padding: EdgeInsets.only(top: 7.0),
                  child: Text(
                    "About Us",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 245, 245, 245),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 56, top: 20),
                      child: Image.asset(
                        'assets/images/tst.png',
                        width: 250,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 25,
                      ),
                      child: Text(
                        "SafeDrive is an application which detect driver drowsiness using latest technologies. SafeDrive basically detects using eye closure and yawning.",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Jersey 15'),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 15, left: 12, right: 12, bottom: 15),
                      child: Divider(
                        color: Color.fromARGB(255, 192, 191, 191),
                        thickness: 0.7,
                        height: 20,
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.only(left: 25),
                        child: Row(
                          children: [
                            Icon(
                              Icons.share,
                              color: Colors.black,
                              size: 30,
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Share this app",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Oswald'),
                            )
                          ],
                        )),
                    const SizedBox(height: 25),
                    const Padding(
                        padding: EdgeInsets.only(top: 10, left: 25),
                        child: Row(
                          children: [
                            Icon(
                              Icons.call,
                              color: Colors.black,
                              size: 30,
                            ),
                            SizedBox(width: 15),
                            Text(
                              "077-123-4567",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Oswald'),
                            )
                          ],
                        )),
                    const SizedBox(height: 25),
                    const Padding(
                        padding: EdgeInsets.only(top: 10, left: 25),
                        child: Row(
                          children: [
                            Icon(
                              Icons.mail,
                              color: Colors.black,
                              size: 30,
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Support@SafeDrive.com",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Oswald'),
                            )
                          ],
                        ))
                  ],
                )),
          ),
        ],
      )),
      bottomNavigationBar: const BottomAppBar(
        height: 40,
        color: Color.fromARGB(255, 241, 239, 239),
        child: Padding(
          padding: EdgeInsets.only(top: 14, left: 5),
          child: Text(
            "Version 1.0.5",
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
