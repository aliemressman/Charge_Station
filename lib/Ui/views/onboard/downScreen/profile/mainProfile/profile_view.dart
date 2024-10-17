import 'package:evry_app/Ui/views/onboard/downScreen/profile/araclar/araclar_view.dart';
import 'package:evry_app/Ui/views/onboard/downScreen/profile/hesabim/hesabim_view.dart';
import 'package:evry_app/Ui/views/onboard/downScreen/profile/kartBilgi/kart_bilgilerim_view.dart';
import 'package:evry_app/product/extensions/context_extension.dart';
import 'package:flutter/services.dart';

import '../../../../../../product/constants/colors.dart';
import '../../../../login/giris_ekrani_view.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // Color Sınıfım
  static Color greyShade600 = AppColors.greyShade600;
  static Color greyShade900 = AppColors.greyShade900;
  static Color whiteColor = AppColors.whiteColor;
  static Color redColor = AppColors.redColor;
  static Color blackColor = AppColors.blackColor;

  // Kullanıcının kayıtlı olup olmadığını temsil eden değişken
  bool isRegistered = true; // Örnek olarak varsayılan kayıt durumu: false

  final List<String> _menuItems = [
    "Hesabım",
    "Kart Bilgilerim",
    "Araçlarım",
    "Fiyatlandırma",
    "Sözleşmeler",
    "Bize Ulaşın",
    "Destek",
    "Çıkış yap"
  ];
  final List<IconData> _menuIcons = [
    Icons.account_circle,
    Icons.credit_card,
    Icons.directions_car,
    Icons.attach_money,
    Icons.description,
    Icons.contact_mail,
    Icons.help,
    Icons.exit_to_app
  ];

  void _navigateToPage(BuildContext context, int index) {
    if (_menuItems[index] == "Çıkış yap") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GirisEkraniView()),
      );
      return;
    }

    switch (_menuItems[index]) {
      case "Hesabım":
        _navigateBasedOnRegistration(context, const HesabimView());
        break;
      case "Kart Bilgilerim":
        _navigateBasedOnRegistration(context, const KartBilgilerimView());
        break;
      case "Araçlarım":
        _navigateBasedOnRegistration(context, const AraclarView());
        break;
      default:
        // Diğer menü öğeleri için farklı işlemler yapabilirsiniz
        print("${_menuItems[index]} öğesine tıklanıldı.");
        break;
    }
  }

  void _navigateBasedOnRegistration(BuildContext context, Widget goScreen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => isRegistered ? goScreen : const GirisEkraniView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          children: [
            Container(
              color: Colors.grey.shade100,
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 35.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('EVRY', style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(children: [
                        const Text('Ali Emre'),
                        SizedBox(width: context.dynamicWidth(0.02)),
                        const CircleAvatar()
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10.0),
                itemCount: _menuItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: index == _menuItems.length - 1 ? redColor : whiteColor,
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    child: ListTile(
                      leading: Icon(
                        _menuIcons[index],
                        color: index == _menuItems.length - 1 ? whiteColor : greyShade600,
                      ),
                      title: Text(
                        _menuItems[index],
                        style: TextStyle(
                          color: index == _menuItems.length - 1 ? whiteColor : greyShade900,
                          fontSize: 18.0,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_right_rounded,
                        color: index == _menuItems.length - 1 ? whiteColor : blackColor,
                      ),
                      onTap: () => _navigateToPage(context, index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
