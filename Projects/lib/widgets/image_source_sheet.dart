import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  /// Called when the user picks a source.
  /// Receives ImageSource.camera or ImageSource.gallery.
  final Function(ImageSource source) onSourceSelected;

  const ImageSourceSheet({
    super.key,
    required this.onSourceSelected,
  });

  /// Static helper so callers don't need to write showModalBottomSheet boilerplate
  static void show(
      BuildContext context, {
        required Function(ImageSource source) onSourceSelected,
      }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ImageSourceSheet(onSourceSelected: onSourceSelected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle — standard Material bottom sheet affordance
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Choose Profile Photo",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOption(
                  context: context,
                  icon: Icons.camera_alt,
                  label: "Camera",
                  source: ImageSource.camera,
                ),
                _buildOption(
                  context: context,
                  icon: Icons.photo_library,
                  label: "Gallery",
                  source: ImageSource.gallery,
                ),
              ],
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    return GestureDetector(
      onTap: () {
        // Close the sheet first, then fire the callback.
        // Order matters: if we fired callback first, the sheet context
        // would still be mounted during the async image pick, which can
        // cause unexpected Navigator state issues.
        Navigator.pop(context);
        onSourceSelected(source);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.orange.shade200, width: 1.5),
            ),
            child: Icon(icon, color: Colors.orange, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}