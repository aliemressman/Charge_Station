import 'package:evry_app/Ui/views/onboard/downScreen/profile/araclar/marka_model_map.dart';
import 'package:evry_app/Ui/views/onboard/downScreen/profile/araclar/marka_sec_view.dart';
import 'package:evry_app/Ui/views/onboard/downScreen/profile/araclar/model_sec_view.dart';
import 'package:evry_app/Ui/views/onboard/downScreen/profile/araclar/widget/arac_ekle_button.dart';
import 'package:evry_app/product/components/appbar/profile_appbar.dart';
import 'package:evry_app/product/constants/colors.dart';
import 'package:evry_app/product/constants/text_const.dart';
import 'package:evry_app/product/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class YeniArac extends StatefulWidget {
  const YeniArac({super.key});

  @override
  State<YeniArac> createState() => _YeniAracState();
}

class _YeniAracState extends State<YeniArac> {
  String selectedMarka = "Marka seç"; // Seçilen marka
  String selectedModel = "Model seç"; // Seçilen model
  List<String> availableModels = []; // Seçilen markaya göre modeller
  String plaka = ""; // Plaka bilgisi

  // Marka seçme sayfasına yönlendirme fonksiyonu
  void _navigateToMarkaSecView() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MarkaSecView()),
    );
    if (result != null) {
      setState(() {
        selectedMarka = result;
        selectedModel = TextConst.modelSec; // Modeli sıfırla
        availableModels = markaModelMap[selectedMarka] ?? [];
      });
    }
  }

  // Model seçme sayfasına yönlendirme fonksiyonu
  void _navigateToModelSecView() async {
    if (availableModels.isNotEmpty) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ModelSecView(selectedMarka: selectedMarka)),
      );
      if (result != null) {
        setState(() {
          selectedModel = result;
        });
      }
    }
  }

  // Araç ekleme butonunun aktifliğini kontrol eden fonksiyon
  bool _canAddVehicle() {
    return selectedMarka != "Marka seç" && selectedModel != "Model seç" && plaka.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ProfileAppbar(title: TextConst.yeniArac),
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19),
                    ),
                    SizedBox(height: context.dynamicHeight(0.02)),
                    Container(
                      height: 1.0,
                      color: AppColors.blueColor,
                      width: double.infinity,
                    ),
                    SizedBox(height: context.dynamicHeight(0.02)),
                    // "Marka seç*" alanı
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: _mSec(context, "Marka seç*"),
                    ),
                    SizedBox(height: context.dynamicHeight(0.01)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: _markaDetector(context),
                    ),
                    SizedBox(height: context.dynamicHeight(0.01)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: _mSec(context, "Model seç*"),
                    ),
                    SizedBox(height: context.dynamicHeight(0.01)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: _modelDetector(context),
                    ),
                    if (availableModels.isEmpty && selectedMarka != "Marka seç")
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text(
                          "Lütfen önce bir marka seçin.",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(height: context.dynamicHeight(0.05)),
                    // Plaka girişi
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                          LengthLimitingTextInputFormatter(8),
                        ],
                        onChanged: (value) {
                          setState(() {
                            plaka = value.toUpperCase(); // Büyük harflerle giriş
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Araç Plakası*',
                          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 15,
                                letterSpacing: 1.5,
                              ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: AppColors.greyColor),
                          ),
                        ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.greyColor,
                              fontSize: 20,
                              letterSpacing: 20,
                            ),
                      ),
                    ),
                    SizedBox(height: context.dynamicHeight(0.02)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child:
                          Text("Büyük harf ile giriş yapınız.", style: TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: AracEkleButton(
          selectedMarka: selectedMarka,
          selectedModel: selectedModel,
          plaka: plaka,
          onPressed: _canAddVehicle()
              ? () {
                  Navigator.pop(context, {
                    'marka': selectedMarka,
                    'model': selectedModel,
                    'plaka': plaka,
                  });
                }
              : null, // Eğer bilgiler eksikse butonu devre dışı bırak
        ),
      ),
    );
  }

  GestureDetector _markaDetector(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToMarkaSecView,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyColor),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedMarka,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
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
      onTap: availableModels.isNotEmpty ? _navigateToModelSecView : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyColor),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedModel,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.greyColor),
          ],
        ),
      ),
    );
  }

  Text _mSec(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 15, color: AppColors.blueColor),
    );
  }
}
