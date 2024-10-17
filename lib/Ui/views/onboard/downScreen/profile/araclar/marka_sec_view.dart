import 'package:evry_app/product/components/appbar/profile_appbar.dart';
import 'package:evry_app/product/constants/colors.dart';
import 'package:evry_app/product/constants/text_const.dart';
import 'package:flutter/material.dart';

class MarkaSecView extends StatelessWidget {
  const MarkaSecView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> markaList = [
      'Audi',
      'BMW',
      'BYD',
      'Chevrolet',
      'Chrysler',
      'Fisker',
      'Ford',
      'Genesis',
      'Hyundai',
      'Jaguar',
      'Kia',
      'Lucid',
      'Mercedes',
      'Nissan',
      'Polestar',
      'Rivian',
      'Tesla',
      'Toyota',
      'Volkswagen',
    ];

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ProfileAppbar(title: TextConst.markaSeciniz),
      ),
      body: ListView.separated(
        itemCount: markaList.length,
        separatorBuilder: (context, index) => Divider(color: AppColors.greyShade300),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(markaList[index]),
            onTap: () {
              Navigator.pop(context, markaList[index]);
            },
          );
        },
      ),
    );
  }
}
