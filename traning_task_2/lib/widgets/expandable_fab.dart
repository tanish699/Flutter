import 'package:flutter/material.dart';
import 'floatingbutton.dart';

class ExpandableFab extends StatefulWidget {
  final VoidCallback onQrTap;
  final VoidCallback onBarTap;

  const ExpandableFab({
    super.key,
    required this.onQrTap,
    required this.onBarTap,
  });

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {

  bool isExpanded = false;

  void toggleFab() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        // ---------------- QR BUTTON ----------------

        if (isExpanded) ...[

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "QR Code",
                ),
              ),

              const SizedBox(width: 10),

              CustomFabButton(
                heroTag: "qr",
                mini: true,
                icon: Icons.qr_code_scanner,
                onPressed: widget.onQrTap,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ---------------- BARCODE BUTTON ----------------

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Bar Code",
                ),
              ),

              const SizedBox(width: 10),

              CustomFabButton(
                heroTag: "bar",
                mini: true,
                icon: Icons.document_scanner,
                onPressed: widget.onBarTap,
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],

        // ---------------- MAIN FAB ----------------

        CustomFabButton(
          heroTag: "main",
          icon: isExpanded
              ? Icons.close
              : Icons.add,
          onPressed: toggleFab,
        ),
      ],
    );
  }
}