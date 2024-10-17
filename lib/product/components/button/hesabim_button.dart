import 'package:evry_app/product/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class HesabimButton extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final VoidCallback? onPressed;
  final Icon? icon; // İkon parametresi eklendi, null olabilir
  final double widthFactor; // Dinamik genişlik için oran
  final double heightFactor; // Dinamik yükseklik için oran

  const HesabimButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    this.onPressed,
    this.icon, // İkon parametresi eklendi
    this.widthFactor = 0.9, // Varsayılan genişlik oranı (ekranın %80'i)
    this.heightFactor = 0.08, // Varsayılan yükseklik oranı (ekranın %8'i)
  });

  @override
  State<HesabimButton> createState() => _HesabimButtonState();
}

class _HesabimButtonState extends State<HesabimButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.dynamicWidth(widget.widthFactor), // Dinamik genişlik
      height: context.dynamicHeight(widget.heightFactor), // Dinamik yükseklik
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(widget.backgroundColor),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: 16.0, // Butonun yatay padding'i
              vertical: 14.0, // Butonun dikey padding'i
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              widget.icon!,
              SizedBox(width: context.dynamicWidth(0.08)), // İkon ile metin arasına boşluk
            ],
            Text(
              widget.text,
              style: TextStyle(color: widget.textColor),
            ),
          ],
        ),
      ),
    );
  }
}
