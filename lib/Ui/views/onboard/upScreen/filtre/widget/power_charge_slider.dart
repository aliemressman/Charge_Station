import 'package:flutter/material.dart';

class PowerChargeSlider extends StatelessWidget {
  final double chargingPower;
  final ValueChanged<double> onChanged;

  const PowerChargeSlider({
    required this.chargingPower,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: chargingPower,
      min: 0,
      max: 200, // Max değerini ihtiyacınıza göre ayarlayın
      divisions: 20,
      label: '${chargingPower.round()} kW',
      onChanged: onChanged,
    );
  }
}
