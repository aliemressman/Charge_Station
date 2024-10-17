import 'package:flutter/material.dart';
import 'package:evry_app/product/components/button/girisEkrani/uye_ol_button.dart';
import 'package:evry_app/product/components/textfield/password_tf.dart';
import 'package:evry_app/product/components/textfield/phone_tf.dart';
import 'package:evry_app/product/extensions/context_extension.dart';
import '../../../product/components/button/misafir_button.dart';
import '../../../product/components/text/text_beni_hatirla.dart';
import '../../../product/components/text/text_hesapyok.dart';
import '../../../product/constants/colors.dart';
import '../../../product/constants/text_const.dart';
import '../onboard/downScreen/home/google_maps_screen.dart';

class GirisEkraniView extends StatefulWidget {
  const GirisEkraniView({super.key});

  @override
  State<GirisEkraniView> createState() => _GirisEkraniViewState();
}

class _GirisEkraniViewState extends State<GirisEkraniView> implements TextConst {
  static const Color greyColor = AppColors.greyColor;
  static Color whiteColor = AppColors.whiteColor;
  static Color boxShodow = AppColors.boxShodow;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [greyColor, greyColor, greyColor],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: context.dynamicHeight(0.15)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.1)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        TextConst.girisYap,
                        style: context.theme.textTheme.displaySmall?.copyWith(color: whiteColor),
                      ),
                      Text(
                        TextConst.hosgeldin,
                        style: context.theme.textTheme.titleLarge?.copyWith(color: whiteColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.dynamicHeight(0.05)),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.1)),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: context.dynamicHeight(0.1)),
                          Container(
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: boxShodow,
                                  blurRadius: 20,
                                  offset: const Offset(10, 10),
                                ),
                              ],
                            ),
                            child: _TextFieldColumn(),
                          ),
                          if (errorMessage != null)
                            Text(
                              errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          SizedBox(height: context.dynamicHeight(0.03)),
                          _centerRow(),
                          const Divider(color: greyColor),
                          SizedBox(height: context.dynamicHeight(0.01)),
                          const TextHesapYok(),
                          SizedBox(height: context.dynamicHeight(0.02)),
                          SizedBox(
                            width: double.infinity,
                            child: girisButton(context),
                          ),
                          const UyeOlButton(),
                          const MisafirButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _ImageLocation(context.dynamicWidth(0), context.dynamicHeight(0)),
        ],
      ),
    );
  }

  ElevatedButton girisButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(context.dynamicHeight(0.02)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () {
        // Giriş yapma işlemi
        final phone = _phoneController.text;
        final password = _passwordController.text;
        if (phone.isEmpty || password.isEmpty) {
          setState(() {
            errorMessage = 'Telefon numarası ve şifre boş olamaz.';
          });
        } else {
          // Telefon numarası ve şifre doğrulama işlemi
          // Başarılıysa GoogleMapsScreen'e geçiş
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GoogleMapsScreen()),
          );
        }
      },
      child: const Text('Giriş Yap'),
    );
  }

  Column _TextFieldColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(),
          child: PhoneTextField(controller: _phoneController), // Kontrolcü eklendi
        ),
        const Divider(color: greyColor, height: 1),
        Container(
          decoration: const BoxDecoration(),
          child: PasswordTextField(controller: _passwordController), // Kontrolcü eklendi
        ),
      ],
    );
  }

  Row _centerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _rememberMe = !_rememberMe;
            });
          },
          child: Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value!;
                  });
                },
              ),
              const TextBeniHatirla(),
            ],
          ),
        ),
      ],
    );
  }

  Positioned _ImageLocation(double width, double height) {
    return Positioned(
      top: context.dynamicHeight(0.01),
      right: context.dynamicWidth(0.08),
      child: Image.asset(
        'assets/verycharge.png',
        width: context.dynamicWidth(0.3),
        height: context.dynamicHeight(0.18),
      ),
    );
  }
}
