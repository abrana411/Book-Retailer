import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController mycontroller;
  final String hinttxt;
  final int maxLines;
  final Icon? icon;
  final bool isForm;
  const CustomTextFormField(
      {super.key,
      required this.mycontroller,
      required this.hinttxt,
      this.maxLines = 1,
      this.icon,
      this.isForm = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: mycontroller,
      decoration: InputDecoration(
        prefixIcon: (icon == null) ? null : icon,
        hintText: hinttxt,
        hintStyle: TextStyle(
          color: (isForm)
              ? const Color.fromRGBO(255, 255, 255, 0.5)
              : Colors.black,
        ),
        // fillColor: Theme.of(context).accentColor,
        filled: isForm,
        border: OutlineInputBorder(
            borderRadius:
                (isForm) ? BorderRadius.circular(8) : BorderRadius.zero,
            borderSide: (!isForm)
                ? const BorderSide(color: Colors.black45)
                : const BorderSide()),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: (isForm) ? Colors.white : Colors.black45,
          ),
        ),
      ),
      // decoration: InputDecoration(
      //   hintText: hinttxt,
      //   border: const OutlineInputBorder(
      //       borderSide: BorderSide(color: Colors.black45)),
      //   enabledBorder: const OutlineInputBorder(
      //       borderSide: BorderSide(color: Colors.black45)),
      // ),

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
