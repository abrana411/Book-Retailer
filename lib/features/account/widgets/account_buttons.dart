import 'package:flutter/material.dart';

class AccountButton extends StatelessWidget {
  //We need the text to show and also the callback function for the button
  final String textToShow;
  final VoidCallback whatWillHappenOnClicking;
  const AccountButton({
    super.key,
    required this.textToShow,
    required this.whatWillHappenOnClicking,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 218, 216, 216),
          borderRadius: BorderRadius.circular(40),
        ),
        child: TextButton(
          onPressed: whatWillHappenOnClicking,
          child: Text(
            textToShow,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
