import 'package:evry_app/Ui/views/onboard/downScreen/profile/araclar/marka_model_map.dart';
import 'package:evry_app/product/components/appbar/profile_appbar.dart';
import 'package:evry_app/product/constants/colors.dart';
import 'package:flutter/material.dart';

class ModelSecView extends StatelessWidget {
  final String selectedMarka; // Seçilen markayı almak için

  const ModelSecView({super.key, required this.selectedMarka});

  @override
  Widget build(BuildContext context) {
    // Seçilen markaya göre modelleri getir
    List<String> models = markaModelMap[selectedMarka] ?? [];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ProfileAppbar(title: "$selectedMarka Modelleri"),
      ),
      body: ListView.separated(
        itemCount: models.length,
        separatorBuilder: (context, index) => Divider(
          color: AppColors.greyShade300,
        ),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(models[index]),
            onTap: () {
              Navigator.pop(context, models[index]);
            },
          );
        },
      ),
    );
  }
}
