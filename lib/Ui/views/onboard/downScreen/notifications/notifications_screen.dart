import 'package:evry_app/product/extensions/context_extension.dart';
import 'package:flutter/material.dart';

import '../../../../../product/constants/colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Color Sınıfım
  static Color greyShade100 = AppColors.greyShade100;
  static const Color greyColor = AppColors.greyColor;

  final bool _hasNotifications = false;

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
              child: _hasNotifications
                  ? Container() // Bildirim varsa burada liste gösterilebilir.
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.notifications, size: 100, color: greyColor),
                        SizedBox(height: context.dynamicHeight(0.02)),
                        const Text(
                          'Bildirim Bulunamadı',
                          style: TextStyle(fontSize: 24, color: greyColor),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
