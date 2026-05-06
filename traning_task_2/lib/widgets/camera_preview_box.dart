import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPreviewBox extends StatefulWidget {

  final double height;
  final double width;
  final Widget fallbackIcon;

  const CameraPreviewBox({
    super.key,
    required this.height,
    required this.width,
    required this.fallbackIcon,
  });

  @override
  State<CameraPreviewBox> createState() => _CameraPreviewBoxState();
}

class _CameraPreviewBoxState extends State<CameraPreviewBox> {

  CameraController? controller;

  bool isPermissionGranted = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    requestCameraPermission();
  }

  // ---------------- REQUEST PERMISSION ----------------

  Future<void> requestCameraPermission() async {

    final status = await Permission.camera.request();

    if (status.isGranted) {

      isPermissionGranted = true;

      await initializeCamera();

    } else {

      setState(() {
        isPermissionGranted = false;
        isLoading = false;
      });
    }
  }

  // ---------------- INITIALIZE CAMERA ----------------

  Future<void> initializeCamera() async {

    final cameras = await availableCameras();

    if (cameras.isNotEmpty) {

      controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
      );

      await controller!.initialize();

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {

    controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: widget.height,
      width: widget.width,

      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.orange,
          width: 4,
        ),

        borderRadius: BorderRadius.circular(20),
      ),

      child: ClipRRect(

        borderRadius: BorderRadius.circular(16),

        child: isLoading

            ? const Center(
          child: CircularProgressIndicator(),
        )

            : isPermissionGranted &&
            controller != null &&
            controller!.value.isInitialized

            ? CameraPreview(controller!)

            : Center(
          child: widget.fallbackIcon,
        ),
      ),
    );
  }
}