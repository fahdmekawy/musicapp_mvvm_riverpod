import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final bool? obscureText;
  final bool? readOnly;
  final TextEditingController? textEditingController;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    this.hintText,
    this.obscureText = false,
    this.textEditingController,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly!,
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
