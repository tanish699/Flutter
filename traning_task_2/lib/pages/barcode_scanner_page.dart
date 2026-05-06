import 'package:flutter/material.dart';

import '../utils/images.dart';
import '../widgets/camera_preview_box.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {

  String scannedResult = "No Barcode code scanned yet";

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("BarCode Scanner"),
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
                  "Place the Barcode Code inside frame.",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ---------- barcode BOX ----------
              Center(
                child: CameraPreviewBox(
                  height: 170,
                  width: 400,

                  fallbackIcon: const Icon(
                    Icons.document_scanner,
                    size: 100,
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