import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class HesabimTf extends StatefulWidget {
  final TextInputType keyboardType;
  final String labelText;
  final String hintText;
  final Icon? icon;
  final String? suffixText;
  final VoidCallback? onSuffixPressed;
  final int? maxLength; // maxLength parametresini ekledik

  const HesabimTf({
    super.key,
    required this.keyboardType,
    required this.labelText,
    required this.hintText,
    this.icon,
    this.suffixText,
    this.onSuffixPressed,
    this.maxLength, // maxLength parametresini ekledik
  });

  @override
  State<HesabimTf> createState() => _HesabimTfState();
}

class _HesabimTfState extends State<HesabimTf> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength, // maxLength özelliğini ekledik
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: AppColors.greyColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.greyColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.greyColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.greyColor),
        ),
        suffixIcon: widget.icon,
        suffix: widget.suffixText != null
            ? InkWell(
                onTap: widget.onSuffixPressed,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    widget.suffixText!,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.redColor, // İsterseniz rengi özelleştirin
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
