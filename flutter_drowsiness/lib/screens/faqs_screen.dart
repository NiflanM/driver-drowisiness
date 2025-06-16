import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      "question": "What is SafeDrive?",
      "answer":
          "SafeDrive is an app that detects driver drowsiness using camera-based monitoring and alerts."
    },
    {
      "question": "How does drowsiness detection work?",
      "answer":
          "It uses facial recognition and eye movement and mouth tracking to detect signs of fatigue."
    },
    {
      "question": "Does SafeDrive work offline?",
      "answer":
          "Currently, SafeDrive requires an internet connection for full functionality."
    },
    {
      "question": "Is my data stored or shared?",
      "answer":
          "No, SafeDrive processes data locally and doesn’t store or share any user data."
    },
    {
      "question": "Can I use SafeDrive in low light conditions?",
      "answer":
          "Yes, SafeDrive is designed to work in various lighting conditions, including low light."
    },
    {
      "question": "How do I report a bug or issue?",
      "answer":
          "You can report bugs or issues through the app's feedback feature or contact support."
    },
    {
      "question": "Is there a premium version of SafeDrive?",
      "answer":
          "Currently, SafeDrive is free to use with all features available at no cost."
    },
    {
      "question": "How do I contact customer support?",
      "answer": "You can contact customer support through the app or via mail."
    },
    {
      "question": "What should I do if the app crashes?",
      "answer":
          "If the app crashes, please restart it and report the issue through the feedback feature."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 247, 247),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "FAQs",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              // <-- fix: wrap ListView in Expanded
              child: ListView.builder(
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Padding(
                      padding: const EdgeInsets.only(top: 02),
                      child: Text(
                        faqs[index]['question']!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          faqs[index]['answer']!,
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("FAQs"),
  //     ),
  // body: ListView.builder(
  //   itemCount: faqs.length,
  //   itemBuilder: (context, index) {
  //     return ExpansionTile(
  //       title: Padding(
  //         padding: const EdgeInsets.only(top: 20),
  //         child: Text(
  //           faqs[index]['question']!,
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  //         ),
  //       ),
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Text(faqs[index]['answer']!,
  //               style: TextStyle(fontSize: 16)),
  //         )
  //       ],
  //     );
  //   },
  // ),
  //   );
  // }
