import 'package:evry_app/product/extensions/context_extension.dart';
import 'package:flutter/material.dart';

import '../../../../../product/constants/colors.dart';

class OperationsScreen extends StatefulWidget {
  const OperationsScreen({super.key});

  @override
  State<OperationsScreen> createState() => _OperationsScreenState();
}

class _OperationsScreenState extends State<OperationsScreen> {
  // Color Sınıfım
  static Color greyShade100 = AppColors.greyShade100;
  static const Color greyColor = AppColors.greyColor;

  final bool _hasOperations = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Container(
            color: greyShade100,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('EVRY', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        const Text('Ali Emre'),
                        SizedBox(width: context.dynamicWidth(0.02)),
                        const CircleAvatar()
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: _hasOperations
                  ? Container() // İşlem varsa burada liste gösterilebilir.
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.access_time, size: 100, color: greyColor),
                        SizedBox(height: context.dynamicHeight(0.02)),
                        const Text('Kayıt Bulunamadı', style: TextStyle(fontSize: 24, color: greyColor)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
