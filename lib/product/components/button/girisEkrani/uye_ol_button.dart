import 'package:flutter/material.dart';

import '../../../../Ui/auth/view/signup/sign_up_view.dart';

class UyeOlButton extends StatefulWidget {
  const UyeOlButton({super.key});

  @override
  State<UyeOlButton> createState() => _UyeOlButtonState();
}

class _UyeOlButtonState extends State<UyeOlButton> {
  @override
  Widget build(BuildContext context) {
    TextButton uyeOlButton(BuildContext context) {
      return TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => SignUpView()),
          );
        },
        child: const Text('Üye Ol'),
      );
    }

    return uyeOlButton(context);
  }
}
