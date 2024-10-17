import 'package:flutter/material.dart';
import 'package:evry_app/product/extensions/context_extension.dart';
import '../../constants/colors.dart';
import '../../constants/text_const.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller; // Controller ekleyin

  const PasswordTextField({
    Key? key,
    required this.controller, // Controller'ı zorunlu hale getirin
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscure = true;
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller, // Controller'ı buraya bağlayın
      focusNode: _passwordFocusNode,
      obscureText: _isObscure,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: TextConst.sifreGir, // Assuming you have a TextConst for password
        hintStyle: const TextStyle(color: AppColors.greyColor),
        border: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.dynamicWidth(0.05), // Dinamik genişlik
          vertical: context.dynamicHeight(0.02), // Dinamik yükseklik
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.greyColor,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
    );
  }
}
