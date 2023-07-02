import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
void ShowSnackBar(
    {required BuildContext context,
    required String text,
    required Color color}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    backgroundColor: color,
  ));
}
