import '../../constants/text_const.dart';
import '../../extensions/context_extension.dart';
import 'package:flutter/material.dart';

class TextBeniHatirla extends StatelessWidget {
  const TextBeniHatirla({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      TextConst.beniHatirla,
      style: context.theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
    );
  }
}
