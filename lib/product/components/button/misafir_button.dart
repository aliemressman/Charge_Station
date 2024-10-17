import 'package:evry_app/Ui/views/onboard/downScreen/home/google_maps_screen.dart';
import '../../constants/text_const.dart';
import '../../extensions/context_extension.dart';
import 'package:flutter/material.dart';

class MisafirButton extends StatefulWidget {
  const MisafirButton({super.key});

  @override
  State<MisafirButton> createState() => _MisafirButtonState();
}

class _MisafirButtonState extends State<MisafirButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GoogleMapsScreen()));
      },
      child: Text(
        TextConst.misafirGirisi,
        style: context.theme.textTheme.bodyLarge?.copyWith(color: Colors.purple[900]),
      ),
    );
  }
}
