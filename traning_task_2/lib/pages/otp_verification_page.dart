import 'package:flutter/material.dart';
import 'home.dart';

class OtpVerificationPage extends StatefulWidget {

  final String generatedOtp;

  const OtpVerificationPage({
    super.key,
    required this.generatedOtp,
  });

  @override
  State<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState
    extends State<OtpVerificationPage> {

  final TextEditingController otpController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("OTP Verification"),
        backgroundColor: Colors.orange.shade300,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            const SizedBox(height: 40),

            const Text(
              "Enter Verification Code",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: otpController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "OTP",
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(

              onPressed: () {

                if (otpController.text.trim() ==
                    widget.generatedOtp) {

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => home(),
                    ),
                  );

                } else {

                  ScaffoldMessenger.of(context)
                      .showSnackBar(

                    const SnackBar(
                      content: Text("Invalid OTP"),
                    ),
                  );
                }
              },

              child: const Text("Verify"),
            ),
          ],
        ),
      ),
    );
  }
}