import 'dart:io';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  /// Path to the locally saved image file.
  /// If null, a default person icon is shown instead.
  final String? imagePath;

  /// Called when the camera badge is tapped.
  /// The parent page handles what happens next (show bottom sheet, etc.)
  final VoidCallback onTap;

  /// How large the avatar circle should be.
  /// Defaults to 55 so it works on both profile and edit profile pages.
  final double radius;

  const ProfileAvatar({
    super.key,
    required this.onTap,
    this.imagePath,
    this.radius = 55,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      // clipBehavior.none ensures the badge isn't clipped by the Stack bounds
      clipBehavior: Clip.none,
      children: [
        _buildAvatar(),
        _buildCameraBadge(),
      ],
    );
  }

  /// The main circle — shows image if available, icon otherwise
  Widget _buildAvatar() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.orange.shade100,

      // FileImage reads from the device's local file system.
      // We only use it when imagePath is non-null to avoid a File("null") crash.
      backgroundImage: imagePath != null
          ? FileImage(File(imagePath!))
          : null,

      // child is only shown when there's no backgroundImage
      child: imagePath == null
          ? Icon(Icons.person, size: radius, color: Colors.orange)
          : null,
    );
  }

  /// The small orange camera icon overlaid at the bottom-right
  Widget _buildCameraBadge() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
            // White border creates separation between badge and avatar
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }
}