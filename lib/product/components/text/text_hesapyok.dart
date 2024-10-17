import '../../constants/text_const.dart';
import '../../extensions/context_extension.dart';
import 'package:flutter/material.dart';

class TextHesapYok extends StatelessWidget {
  const TextHesapYok({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      TextConst.hesapYok,
      style: context.theme.textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
