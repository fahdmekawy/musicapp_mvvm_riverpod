import 'package:flutter/material.dart';

void showSnackBack(BuildContext context, String content,
    {bool isError = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          content,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: isError == true ? Colors.red : Colors.green,
      ),
    );
}
