import 'package:flutter/material.dart';

class CustomRadioGroup extends StatelessWidget {
  final List<String> options;
  final String? selectedValue;
  final Function(String) onChanged;

  const CustomRadioGroup({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.map((option) {
        return Expanded(
          child: Row(
            children: [
              Radio<String>(
                value: option,
                groupValue: selectedValue,
                onChanged: (val) => onChanged(val!),
              ),
              Text(option),
            ],
          ),
        );
      }).toList(),
    );
  }
}