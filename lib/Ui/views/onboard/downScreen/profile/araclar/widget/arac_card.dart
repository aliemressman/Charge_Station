import 'package:evry_app/Ui/views/onboard/downScreen/profile/araclar/arac_duzenleme.dart';
import 'package:evry_app/product/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:evry_app/product/constants/colors.dart';

class AracCard extends StatelessWidget {
  final int aracId;
  final String marka;
  final String model;
  final String plaka;
  final VoidCallback onEdit;

  const AracCard({
    super.key,
    required this.marka,
    required this.model,
    required this.plaka,
    required this.onEdit,
    required this.aracId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Marka: $marka',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.greyColor,
                  ),
                ),
                Text(
                  'Model: $model',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.dynamicHeight(0.02)),
            Divider(
              color: AppColors.blackColor,
              thickness: 1,
            ),
            SizedBox(height: context.dynamicHeight(0.02)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Plaka: $plaka',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.blackColor,
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    foregroundColor: AppColors.blackColor,
                    side: BorderSide(color: AppColors.blackColor),
                  ),
                  child: const Text('Düzenle'),
                  onPressed: () async {
                    final updatedValues = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AracDuzenlemeSayfasi(
                          marka: marka,
                          model: model,
                          plaka: plaka,
                          aracId: aracId, // Araç ID'sini buraya ekliyoruz
                        ),
                      ),
                    );

                    if (updatedValues != null && updatedValues['deleted'] == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Araç silindi')),
                      );
                      // Listeyi güncellemek için uygun bir yöntemi çağırın
                    } else if (updatedValues != null) {
                      print('Güncellenmiş Veriler: $updatedValues');
                      // Listeyi güncellemek için uygun bir yöntemi çağırın
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: context.dynamicHeight(0.02)),
          ],
        ),
      ),
    );
  }
}
