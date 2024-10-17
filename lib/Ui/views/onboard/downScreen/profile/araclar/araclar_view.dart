import 'package:evry_app/Ui/views/onboard/downScreen/profile/araclar/arac_duzenleme.dart';
import 'package:evry_app/product/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:evry_app/product/constants/colors.dart';
import 'package:evry_app/product/components/button/hesabim_button.dart';
import 'package:evry_app/Ui/views/onboard/downScreen/profile/araclar/widget/arac_card.dart';
import 'package:evry_app/Ui/views/onboard/downScreen/profile/araclar/yeni_arac.dart';
import 'package:evry_app/product/components/appbar/profile_appbar.dart';
import 'package:evry_app/product/constants/text_const.dart';
import '../../../../../../core/database/araclar_data_base.dart';

class AraclarView extends StatefulWidget {
  final String? marka;
  final String? model;
  final String? plaka;

  const AraclarView({
    super.key,
    this.marka,
    this.model,
    this.plaka,
  });

  @override
  State<AraclarView> createState() => _AraclarViewState();
}

class _AraclarViewState extends State<AraclarView> {
  final List<Map<String, dynamic>> araclar = [];

  @override
  void initState() {
    super.initState();
    if (widget.marka != null && widget.model != null && widget.plaka != null) {
      _addArac({
        'marka': widget.marka ?? 'Marka belirtilmedi',
        'model': widget.model ?? 'Model belirtilmedi',
        'plaka': widget.plaka ?? 'Plaka belirtilmedi',
      });
    }
    _loadAraclar();
  }

  // Veritabanından araçları yükle
  Future<void> _loadAraclar() async {
    final dbHelper = DatabaseHelper();
    final araclarList = await dbHelper.getAraclar();
    setState(() {
      araclar.clear();
      araclar.addAll(araclarList);
    });
  }

  // Veritabanına araç ekle
  Future<void> _saveArac(Map<String, dynamic> arac) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.insertArac(arac);
  }

  // Yeni araç ekleme
  Future<void> _addArac(Map<String, dynamic> arac) async {
    setState(() {
      araclar.add(arac);
    });
    await _saveArac(arac); // Veritabanına kaydet
  }

  // Araç düzenleme sayfasına git
  Future<void> _navigateToAracDuzenlemeSayfasi(int index) async {
    final arac = araclar[index];
    final updatedValues = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AracDuzenlemeSayfasi(
          marka: arac['marka'] ?? 'Marka belirtilmedi',
          model: arac['model'] ?? 'Model belirtilmedi',
          plaka: arac['plaka'] ?? 'Plaka belirtilmedi',
          aracId: arac['id'] ?? 0, // Araç ID'sini buraya ekleyin
        ),
      ),
    );

    if (updatedValues != null) {
      if (updatedValues['deleted'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Araç silindi')),
        );
        // Listeyi güncellemek için araçları yeniden yükle
        await _loadAraclar();
      } else {
        // Güncellenmiş verilerle listeyi güncelle
        await _loadAraclar();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ProfileAppbar(title: TextConst.araclarim),
      ),
      body: Column(
        children: [
          Expanded(
            child: araclar.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.directions_car,
                          size: 100,
                          color: AppColors.greyColor,
                        ),
                        SizedBox(height: context.dynamicHeight(0.02)),
                        const Text(
                          'Henüz bir aracınız yok',
                          style: TextStyle(fontSize: 24, color: AppColors.greyColor),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: araclar.length,
                    itemBuilder: (context, index) {
                      final arac = araclar[index];
                      return AracCard(
                        aracId: arac['id'] ?? 0,
                        marka: arac['marka'] ?? 'Marka belirtilmedi',
                        model: arac['model'] ?? 'Model belirtilmedi',
                        plaka: arac['plaka'] ?? 'Plaka belirtilmedi',
                        onEdit: () async {
                          await _navigateToAracDuzenlemeSayfasi(index);
                          _loadAraclar();
                        },
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: HesabimButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const YeniArac(),
                  ),
                );
                if (result != null && result is Map<String, String>) {
                  _addArac(result); // Yeni araç bilgilerini ekle
                }
              },
              text: "Yeni Araç ekle",
              backgroundColor: AppColors.blueColor,
              textColor: AppColors.whiteColor,
              borderColor: AppColors.blueColor,
              icon: Icon(
                Icons.directions_car,
                color: AppColors.whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
