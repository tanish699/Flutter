import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ImageService {
  // ImagePicker is the object that opens camera/gallery
  final ImagePicker _picker = ImagePicker();

  /// Opens camera or gallery depending on [source]
  /// Returns the cropped File, or null if user cancelled
  Future<File?> pickAndCropImage({
    required ImageSource source, // camera or gallery
    required BuildContext context,
  }) async {
    // Step 1: Pick the image from camera or gallery
    // XFile is a cross-platform file representation
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      // We request max dimensions to reduce memory usage before cropping
      maxWidth: 1800,
      maxHeight: 1800,
      // imageQuality 85 reduces file size while keeping good visual quality
      imageQuality: 85,
    );

    // User cancelled the picker (tapped back)
    if (pickedFile == null) return null;

    // Step 2: Check file size — reject if over 10MB
    final file = File(pickedFile.path);
    final fileSizeInBytes = await file.length();
    final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

    if (fileSizeInMB > 10) {
      // Show error to user — we need context for this
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image is too large. Please choose an image under 10MB.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }

    // Step 3: Open the cropper with the picked image
    final croppedFile = await _cropImage(
      imagePath: pickedFile.path,
      context: context,
    );

    return croppedFile;
  }

  /// Opens the image cropper UI
  Future<File?> _cropImage({
    required String imagePath,
    required BuildContext context,
  }) async {
    // CroppedFile? means it can be null (user cancelled cropping)
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      // The path of the image we want to crop
      sourcePath: imagePath,

      // uiSettings controls how the cropper looks on each platform
      uiSettings: [
        // Android-specific settings
        AndroidUiSettings(
          toolbarTitle: 'Image Cropper',
          toolbarColor: Colors.orange,        // Matches your app theme
          toolbarWidgetColor: Colors.white,   // Icon/text color in toolbar
          activeControlsWidgetColor: Colors.orange, // Crop handles color
          backgroundColor: Colors.black,      // Background behind image

          statusBarColor: Colors.deepOrange,        // color of the status bar area
          cropFrameColor: Colors.orange,
          dimmedLayerColor: Colors.black54,

          // CropAspectRatioPreset defines the shape options the user sees
          // square = 1:1, original = keep original proportions
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false, // Allow user to freely adjust
        ),

        // iOS-specific settings
        // IOSUiSettings(
        //   title: 'Image Cropper',
        //   aspectRatioLockEnabled: false,
        //   resetAspectRatioEnabled: true,
        //   aspectRatioPickerButtonHidden: false,
        // ),
      ],
    );

    // If user cancelled cropping, return null
    if (croppedFile == null) return null;

    // Convert CroppedFile to a standard dart:io File
    return File(croppedFile.path);
  }
}