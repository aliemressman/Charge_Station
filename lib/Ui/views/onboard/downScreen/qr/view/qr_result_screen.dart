import 'package:evry_app/product/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:evry_app/product/components/appbar/profile_appbar.dart';
import 'package:evry_app/product/constants/text_const.dart';

class QrResultScreen extends StatelessWidget {
  final String qrText;

  const QrResultScreen({super.key, required this.qrText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ProfileAppbar(title: TextConst.qrBaslik),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'QR Kodun Adresi:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                child: Text(
                  qrText,
                  style: const TextStyle(fontSize: 18, color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: context.dynamicHeight(0.02)),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(), // Geri butonu
                child: const Text('Geri Dön'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
