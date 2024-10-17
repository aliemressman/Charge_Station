import 'package:evry_app/product/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:evry_app/Ui/views/onboard/downScreen/profile/araclar/marka_model_map.dart';
import 'package:evry_app/product/components/appbar/profile_appbar.dart';
import 'package:evry_app/product/constants/colors.dart';
import 'package:evry_app/product/constants/text_const.dart';
import 'package:evry_app/Ui/views/onboard/downScreen/profile/araclar/marka_sec_view.dart';
import 'package:evry_app/Ui/views/onboard/downScreen/profile/araclar/model_sec_view.dart';

import '../../../../../../core/database/araclar_data_base.dart';

class AracDuzenlemeSayfasi extends StatefulWidget {
  final String marka;
  final String model;
  final String plaka;
  final int aracId; // Araç ID'si eklendi

  const AracDuzenlemeSayfasi({
    super.key,
    required this.marka,
    required this.model,
    required this.plaka,
    required this.aracId, // Araç ID'si eklendi
  });

  @override
  _AracDuzenlemeSayfasiState createState() => _AracDuzenlemeSayfasiState();
}

class _AracDuzenlemeSayfasiState extends State<AracDuzenlemeSayfasi> {
  bool shouldDelete = false;
  late String _marka;
  late String _model;
  late TextEditingController _plakaController;
  List<String> availableModels = [];

  @override
  void initState() {
    super.initState();
    _marka = widget.marka;
    _model = widget.model;
    _plakaController = TextEditingController(text: widget.plaka);

    // Markaya göre modelleri güncelle
    availableModels = markaModelMap[_marka] ?? [];
  }

  @override
  void dispose() {
    _plakaController.dispose();
    super.dispose();
  }

  void _navigateToMarkaSecView() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MarkaSecView()),
    );
    if (result != null) {
      setState(() {
        _marka = result;
        _model = TextConst.modelSec; // Modeli sıfırla
        availableModels = markaModelMap[_marka] ?? [];
      });
    }
  }

  void _navigateToModelSecView() async {
    if (availableModels.isNotEmpty) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ModelSecView(selectedMarka: _marka)),
      );
      if (result != null) {
        setState(() {
          _model = result;
        });
      }
    }
  }

  void _saveChanges() {
    Navigator.pop(context, {
      'marka': _marka,
      'model': _model,
      'plaka': _plakaController.text,
    });
  }

  void _deleteVehicle() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Araç Sil'),
          content: const Text('Bu aracı silmek istediğinize emin misiniz?'),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Sil'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      final dbHelper = DatabaseHelper();
      await dbHelper.deleteArac(widget.aracId); // Araç ID'si kullanıldı

      Navigator.pop(context, {'deleted': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ProfileAppbar(title: TextConst.aracDuzenle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          children: [
            SizedBox(height: context.dynamicHeight(0.02)),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Araç Bilgileri',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 19,
                            color: AppColors.blackColor,
                          ),
                    ),
                    SizedBox(height: context.dynamicHeight(0.02)),
                    Container(
                      height: 1.0,
                      color: AppColors.blueColor,
                      width: double.infinity,
                    ),
                    SizedBox(height: context.dynamicHeight(0.02)),
                    // Marka seçme alanı
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: _mSec(context, "Marka seç*"),
                    ),
                    SizedBox(height: context.dynamicHeight(0.02)),
                    _markaDetector(context),
                    SizedBox(height: context.dynamicHeight(0.02)),
                    // Model seçme alanı
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: _mSec(context, "Model seç*"),
                    ),
                    SizedBox(height: context.dynamicHeight(0.02)),
                    _modelDetector(context),
                    if (availableModels.isEmpty && _marka != "Marka seç")
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text(
                          "Lütfen önce bir marka seçin.",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(height: context.dynamicHeight(0.02)),
                    // Plaka girişi
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: TextField(
                        controller: _plakaController,
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                          LengthLimitingTextInputFormatter(8),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Plaka*',
                          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 15,
                                color: AppColors.greyColor,
                              ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: AppColors.greyColor),
                          ),
                        ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 20,
                              color: AppColors.greyColor,
                              letterSpacing: 1.5,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity, // Buton genişliği ekran genişliğine uyacak şekilde ayarlandı
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20), // Daha yüksek buton
                  textStyle: const TextStyle(fontSize: 18), // Daha büyük metin
                ),
                child: const Text(
                  'Kaydet',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: context.dynamicHeight(0.02)), // Butonlar arasında boşluk
            SizedBox(
              width: double.infinity, // Buton genişliği ekran genişliğine uyacak şekilde ayarlandı
              child: ElevatedButton(
                onPressed: _deleteVehicle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Kırmızı renk
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20), // Daha yüksek buton
                  textStyle: const TextStyle(fontSize: 18), // Daha büyük metin
                ),
                child: const Text(
                  'Araç Sil',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _markaDetector(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToMarkaSecView,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyColor),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _marka.isNotEmpty ? _marka : "Marka seç",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 20,
                    color: AppColors.blackColor,
                    letterSpacing: 1.5,
                  ),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.greyColor),
          ],
        ),
      ),
    );
  }

  GestureDetector _modelDetector(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToModelSecView,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyColor),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _model.isNotEmpty ? _model : "Model seç",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 20,
                    color: AppColors.blackColor,
                    letterSpacing: 1.5,
                  ),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.greyColor),
          ],
        ),
      ),
    );
  }

  Widget _mSec(BuildContext context, String label) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.greyColor),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 15,
                  color: AppColors.greyColor,
                ),
          ),
          const Icon(Icons.arrow_drop_down, color: AppColors.greyColor),
        ],
      ),
    );
  }
}
