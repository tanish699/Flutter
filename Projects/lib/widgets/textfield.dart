import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? !isPasswordVisible : false,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off,
            color: Colors.orange,
          ),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field is required";
        }
        if (!widget.isPassword && !value.contains("@")) {
          return "Enter valid email";
        }
        return null;
      },
    );
  }
}