import 'package:flutter/material.dart';

class SingleProduct extends StatelessWidget {
  final String imageSrc;
  const SingleProduct({super.key, required this.imageSrc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
      child: Image.network(
        imageSrc,
        fit: BoxFit.fitHeight,
        // width: 200,
      ),
    );
  }
}
