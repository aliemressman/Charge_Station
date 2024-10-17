import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:evry_app/product/extensions/context_extension.dart';
import '../../constants/colors.dart'; // Renkler için import

class PhoneTextField extends StatefulWidget {
  final TextEditingController controller; // Controller ekleyin

  const PhoneTextField({
    Key? key,
    required this.controller, // Controller'ı zorunlu hale getirin
  }) : super(key: key);

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  String? errorMessage;
  Color borderColor = AppColors.greyColor; // Varsayılan renk

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller, // Controller'ı buraya bağlayın
      onChanged: (value) {},
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Sadece rakam girişi
        LengthLimitingTextInputFormatter(10), // 10 haneli sınır
      ],
      decoration: InputDecoration(
        prefixText: '+90 ', // Ülke kodu burada eklenir
        labelText: "Telefon Numarası", // Metin sabitlerinden etiket
        errorText: errorMessage,
        border: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.dynamicWidth(0.05), // Dinamik genişlik
          vertical: context.dynamicHeight(0.02), // Dinamik yükseklik
        ),
      ),
      keyboardType: TextInputType.phone,
    );
  }
}
