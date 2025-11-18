import 'package:flutter/material.dart';

class AmountField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final void Function(String)? onChanged;

  const AmountField({
    super.key,
    required this.controller,
    required this.label,
    this.icon = Icons.attach_money,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      onChanged: onChanged,
    );
  }
}

class NotesField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLength;
  final void Function(String)? onChanged;

  const NotesField({
    super.key,
    required this.controller,
    required this.label,
    this.maxLength = 200,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        hintText: '$label (${controller.text.length}/$maxLength)',
        prefixIcon: const Icon(Icons.note_alt_outlined),
      ),
      onChanged: onChanged,
    );
  }
}
