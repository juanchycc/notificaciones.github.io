import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput(
      {super.key,
      required this.hintText,
      required this.controller,
      this.maxLines});
  final String hintText;
  final TextEditingController controller;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
          fillColor: Colors.black.withOpacity(0.2),
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red.shade400)),
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red.shade400)),
          hintStyle: const TextStyle(color: Colors.black)),
    );
  }
}
