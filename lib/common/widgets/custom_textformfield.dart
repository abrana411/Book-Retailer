import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController mycontroller;
  final String hinttxt;
  final int maxLines;
  const CustomTextFormField({
    super.key,
    required this.mycontroller,
    required this.hinttxt,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: mycontroller,
      decoration: InputDecoration(
        hintText: hinttxt,
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black45)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black45)),
      ),

      //validator to check for the validation of this field
      validator: (val) {
        if (val == null || val.isEmpty) {
          return "Please enter your $hinttxt to proceed";
        }
        return null; //if successfully validated
      },
      maxLines: maxLines,
    );
  }
}
