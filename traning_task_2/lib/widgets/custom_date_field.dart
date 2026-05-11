import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime)? onDateSelected;
  final String? Function(String?)? validator;

  const CustomDateField({
    super.key,
    required this.label,
    required this.controller,
    required this.firstDate,
    required this.lastDate,
    this.onDateSelected,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        DateTime initialDate = DateTime.now();

        if (controller.text.isNotEmpty) {
          try {
            initialDate = DateFormat('dd/MM/yyyy').parse(controller.text);
          } catch (_) {}
        }

        final pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
        );

        if (pickedDate != null) {
          controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);

          if (onDateSelected != null) {
            onDateSelected!(pickedDate);
          }
        }
      },
      validator: validator,
    );
  }
}