import 'package:flutter/material.dart';

class CustomFabButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String heroTag;
  final Color backgroundColor;
  final bool mini;

  const CustomFabButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.heroTag,
    this.backgroundColor = Colors.orange,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      mini: mini,
      backgroundColor: backgroundColor,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}