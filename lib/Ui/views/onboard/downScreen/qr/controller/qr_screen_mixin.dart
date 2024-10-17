import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

mixin QrScreenMixin<T extends StatefulWidget> on State<T> {
  MobileScannerController mobileScannerController = MobileScannerController();
  bool isFlashOn = false; // Flaş durumu
  String qrText = ''; // QR kodun içeriği
  bool isPermissionGranted = false; // İzin durumu
  bool isPermissionDenied = false; // İzin reddedilme durumu

  @override
  void initState() {
    super.initState();
    checkAndRequestPermission(); // Kamera izni kontrolü
  }

  Future<void> checkAndRequestPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        isPermissionGranted = true;
      });
    } else if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      final result = await Permission.camera.request();
      if (result.isGranted) {
        setState(() {
          isPermissionGranted = true;
        });
      } else {
        setState(() {
          isPermissionDenied = true;
        });
      }
    }
  }

  void toggleFlash() async {
    try {
      await mobileScannerController.toggleTorch();
      setState(() {
        isFlashOn = !isFlashOn;
      });
    } catch (e) {
      print('Flash could not be toggled: $e');
    }
  }

  @override
  void dispose() {
    mobileScannerController.dispose();
    super.dispose();
  }
}
