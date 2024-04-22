import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Unknown extends StatelessWidget {
  const Unknown({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Unknown Page",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "404",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(
              height: 50,
              width: 400,
              child: ElevatedButton(
                onPressed: () {
                  Get.offAllNamed("/home");
                },
                child: const Text(
                  "Return To Home Page",
                  style: TextStyle(
                    fontSize: 23,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
