import 'package:evry_app/Ui/views/onboard/upScreen/filtre/widget/power_charge_slider.dart';
import 'package:evry_app/main.dart';
import 'package:evry_app/product/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import '../../../../../../product/constants/colors.dart';
import '../widget/filter_card.dart';
import '../widget/other_filters.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // Filtre durumları
  bool _dcCcsSelected = false;
  bool _acType2Selected = false;
  bool _dcChademoSelected = false;
  bool _acType2PlugSelected = false;

  // Diğer filtreler için switch durumları
  bool _otherFilter1Selected = false;
  bool _otherFilter2Selected = false;
  bool _otherFilter3Selected = false;
  bool _otherFilter4Selected = false;

  // Şarj gücü için slider değeri
  double _chargingPower = 0;

  void _clearFilters() {
    setState(() {
      _dcCcsSelected = false;
      _acType2Selected = false;
      _dcChademoSelected = false;
      _acType2PlugSelected = false;
      _chargingPower = 0;

      // Diğer filtreleri temizle
      _otherFilter1Selected = false;
      _otherFilter2Selected = false;
      _otherFilter3Selected = false;
      _otherFilter4Selected = false;
    });
  }

  void _handleOtherFilterChanged(String title, bool? value) {
    setState(() {
      switch (title) {
        case 'Uygun Soketler':
          _otherFilter1Selected = value ?? false;
          break;
        case 'Ultra Hızlı (HPC) İstasyonlar':
          _otherFilter2Selected = value ?? false;
          break;
        case 'Yüksek Hızlı (DC) İstasyonlar':
          _otherFilter3Selected = value ?? false;
          break;
        case 'Halka Açık İstasyonlar':
          _otherFilter4Selected = value ?? false;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Filtreler',
            style: TextStyle(letterSpacing: 1),
          ),
          actions: [
            TextButton(
              onPressed: _clearFilters,
              child: Text(
                'Temizle',
                style: TextStyle(color: AppColors.redColor),
              ),
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          flexibleSpace: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.backgroundColor,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Uygun Soketler", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500)),
                    Row(
                      children: [
                        Expanded(
                          child: FilterCard(
                            title: 'DC CCS',
                            icon: Icons.flash_on,
                            isSelected: _dcCcsSelected,
                            onChanged: (value) {
                              setState(() {
                                _dcCcsSelected = value ?? false;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: context.dynamicWidth(0.04)),
                        Expanded(
                          child: FilterCard(
                            title: 'AC Type 2',
                            icon: Icons.flash_on,
                            isSelected: _acType2Selected,
                            onChanged: (value) {
                              setState(() {
                                _acType2Selected = value ?? false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.dynamicHeight(0.02)),
                    Row(
                      children: [
                        Expanded(
                          child: FilterCard(
                            title: 'DC CHAdeMO',
                            icon: Icons.flash_on,
                            isSelected: _dcChademoSelected,
                            onChanged: (value) {
                              setState(() {
                                _dcChademoSelected = value ?? false;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: context.dynamicWidth(0.04)),
                        Expanded(
                          child: FilterCard(
                            title: 'AC Type 2 Plug',
                            icon: Icons.flash_on,
                            isSelected: _acType2PlugSelected,
                            onChanged: (value) {
                              setState(() {
                                _acType2PlugSelected = value ?? false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.dynamicHeight(0.04)),
                    const Text(
                      'Şarj Gücü (kW)',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: context.dynamicHeight(0.02)),
                    PowerChargeSlider(
                      chargingPower: _chargingPower,
                      onChanged: (value) {
                        setState(() {
                          _chargingPower = value;
                        });
                      },
                    ),
                    SizedBox(height: context.dynamicHeight(0.02)),
                    const Text(
                      'Diğer Filtrelemeler',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    OtherFilters(
                      otherFilter1Selected: _otherFilter1Selected,
                      otherFilter2Selected: _otherFilter2Selected,
                      otherFilter3Selected: _otherFilter3Selected,
                      otherFilter4Selected: _otherFilter4Selected,
                      onFilterChanged: _handleOtherFilterChanged, // Burada doğru fonksiyon çağrılıyor
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  // Uygula butonuna tıklandığında yapılacak işlemler
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.redColor,
                  padding: EdgeInsets.symmetric(vertical: context.dynamicHeight(0.03)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Uygula',
                  style: TextStyle(
                    color: Colors.grey[200],
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
