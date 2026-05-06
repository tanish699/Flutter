import 'package:flutter/material.dart';

import '../widgets/camera_preview_box.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {

  String scannedResult = "No QR code scanned yet";

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("QR Scanner"),
        centerTitle: true,
        backgroundColor: Colors.orange.shade300,
      ),

      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 25,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [

              // ---------- TOP TEXT ----------

              const Align(
                alignment: Alignment.center,

                child: Text(
                  "Place the QR Code inside frame.",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ---------- QR BOX ----------
              Center(
                child: CameraPreviewBox(
                  height: 250,
                  width: 250,

                  fallbackIcon: const Icon(
                    Icons.qr_code_scanner,
                    size: 120,
                    color: Colors.orange,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ---------- RESULT TITLE ----------

              const Text(
                "Scanned Result:",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // ---------- RESULT BOX ----------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Text(
                  scannedResult,
                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}