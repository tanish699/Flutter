import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;
  final bool showError;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.orange,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(!value),
                child: const Text.rich(
                  TextSpan(
                    text: "I agree to ",
                    children: [
                      TextSpan(
                        text: "terms & conditions",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        if (showError)
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              "You must accept terms",
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}