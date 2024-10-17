import 'package:flutter/material.dart';

class OtpText1 extends StatelessWidget {
  const OtpText1({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Doğrulama",
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
    );
  }
}
