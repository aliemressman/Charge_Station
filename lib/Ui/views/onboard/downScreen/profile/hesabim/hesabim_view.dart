import 'package:evry_app/product/components/appbar/profile_appbar.dart';
import 'package:evry_app/product/components/button/hesabim_button.dart';
import 'package:evry_app/product/components/textfield/hesabim_tf.dart';
import 'package:evry_app/product/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:evry_app/product/constants/colors.dart';
import 'package:evry_app/product/constants/text_const.dart';

class HesabimView extends StatefulWidget {
  const HesabimView({super.key});

  @override
  State<HesabimView> createState() => _HesabimViewState();
}

class _HesabimViewState extends State<HesabimView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ProfileAppbar(title: TextConst.hesabim),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: context.dynamicHeight(0.05)),
              Container(
                padding: EdgeInsets.all(context.dynamicWidth(0.08)),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Text(
                  'AŞ',
                  style: TextStyle(
                    fontSize: 40.0,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: context.dynamicHeight(0.02)),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.04)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detayları görüntüle',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19),
                      ),
                      SizedBox(height: context.dynamicHeight(0.02)),
                      Container(
                        height: 1.0,
                        color: AppColors.blueColor,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: context.dynamicHeight(0.02)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.04)),
                child: HesabimTf(
                  keyboardType: TextInputType.text,
                  labelText: "Adınız",
                  hintText: "Adınız",
                  icon: Icon(
                    Icons.edit,
                    color: AppColors.greyShade600,
                  ),
                ),
              ),
              SizedBox(height: context.dynamicHeight(0.02)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.04)),
                child: HesabimTf(
                  keyboardType: TextInputType.text,
                  labelText: "Soyadınız",
                  hintText: "Soyadınız",
                  icon: Icon(
                    Icons.edit,
                    color: AppColors.greyShade600,
                  ),
                ),
              ),
              SizedBox(height: context.dynamicHeight(0.02)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.04)),
                child: HesabimTf(
                  keyboardType: TextInputType.emailAddress,
                  labelText: "E-posta",
                  hintText: "E-posta",
                  icon: Icon(Icons.edit, color: AppColors.greyShade600),
                ),
              ),
              SizedBox(height: context.dynamicHeight(0.02)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.04)),
                child: HesabimTf(
                  maxLength: 11,
                  keyboardType: TextInputType.phone,
                  labelText: "Telefon Numarası",
                  hintText: "Telefon Numarası",
                  icon: Icon(
                    Icons.edit,
                    color: AppColors.greyShade600,
                  ),
                ),
              ),
              SizedBox(height: context.dynamicHeight(0.02)),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.04)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Şifre Bilgilerim",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19),
                      ),
                      SizedBox(height: context.dynamicHeight(0.02)),
                      Container(
                        height: 1.0,
                        color: AppColors.blueColor,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: context.dynamicHeight(0.02)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.04)),
                child: HesabimTf(
                  suffixText: "Şifremi Değiştir",
                  onSuffixPressed: () {
                    // Şifre değiştirme işlevini burada tanımlayın
                  },
                  keyboardType: TextInputType.text,
                  labelText: "Şifre",
                  hintText: "Şifre",
                  icon: null,
                ),
              ),
              SizedBox(height: context.dynamicHeight(0.03)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.04)),
                child: HesabimButton(
                  onPressed: () {},
                  borderColor: AppColors.blueColor,
                  backgroundColor: AppColors.blueColor,
                  text: "Kaydet",
                  textColor: AppColors.whiteColor,
                ),
              ),
              SizedBox(height: context.dynamicHeight(0.02)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.04)),
                child: HesabimButton(
                  onPressed: () {},
                  borderColor: AppColors.redColor,
                  backgroundColor: AppColors.whiteColor,
                  text: "Hesabımı Sil",
                  textColor: AppColors.redColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
