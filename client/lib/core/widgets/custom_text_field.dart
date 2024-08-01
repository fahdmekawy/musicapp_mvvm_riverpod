import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final bool? obscureText;
  final TextEditingController textEditingController;

  const CustomTextField({
    super.key,
    this.hintText,
    this.obscureText = false,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      obscureText: obscureText!,
      obscuringCharacter: 'X',
      decoration: InputDecoration(hintText: hintText),
      validator: (value) {
        if (value!.trim().isEmpty) {
          return '$hintText cannot be empty';
        }
        return null;
      },
    );
  }
}
