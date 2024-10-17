import 'package:evry_app/Ui/views/onboard/downScreen/profile/araclar/araclar_view.dart';
import 'package:evry_app/core/database/araclar_data_base.dart';
import 'package:evry_app/product/constants/colors.dart';
import 'package:flutter/material.dart';

class AracEkleButton extends StatefulWidget {
  final String? selectedMarka;
  final String? selectedModel;
  final String? plaka;

  const AracEkleButton({
    super.key,
    this.selectedMarka,
    this.selectedModel,
    this.plaka,
    Null Function()? onPressed,
  });

  @override
  State<AracEkleButton> createState() => _AracEkleButtonState();
}

class _AracEkleButtonState extends State<AracEkleButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isButtonEnabled()
          ? () async {
              final dbHelper = DatabaseHelper();
              await dbHelper.insertArac({
                'marka': widget.selectedMarka!,
                'model': widget.selectedModel!,
                'plaka': widget.plaka!,
              });

              // Araç ekleme işlemi tamamlandıktan sonra kullanıcıyı araçlar sayfasına yönlendirin
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AraclarView(),
                ),
              );
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isButtonEnabled() ? AppColors.blueColor : AppColors.greyColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text(
        'Araç Ekle',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  bool _isButtonEnabled() {
    return widget.selectedMarka != null && widget.selectedModel != null && _isPlakaValid();
  }

  bool _isPlakaValid() {
    if (widget.plaka == null || widget.plaka!.isEmpty) {
      return false;
    }
    final regExp1 = RegExp(r'^\d{2}[A-Z]{2}\d{4}$'); // 2 rakam 2 harf 4 rakam
    final regExp2 = RegExp(r'^\d{2}[A-Z]{3}\d{2}$'); // 2 rakam 3 harf 2 rakam
    return regExp1.hasMatch(widget.plaka!) || regExp2.hasMatch(widget.plaka!);
  }
}
