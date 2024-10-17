import 'package:flutter/material.dart';

class OtpText3 extends StatelessWidget {
  const OtpText3({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Kod gönderilemedi mi?",
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black54,
          ),
    );
  }
}
