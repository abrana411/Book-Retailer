import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String toShow;
  final VoidCallback onTap;
  final Color? btnColor;
  const CustomButton({
    super.key,
    required this.toShow,
    required this.onTap,
    this.btnColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 45),
          backgroundColor: btnColor),
      onPressed: onTap,
      child: Text(toShow),
    );
  }
}
