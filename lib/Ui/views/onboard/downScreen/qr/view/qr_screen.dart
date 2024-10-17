import 'package:evry_app/product/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controller/qr_screen_mixin.dart';
import 'package:evry_app/product/constants/colors.dart';
import 'qr_result_screen.dart'; // QR kod sonuç ekranını import edin

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> with QrScreenMixin, WidgetsBindingObserver, RouteAware {
  bool _isNavigated = false; // Sadece bir defa geçiş yapılması için kontrol

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Geri dönüldüğünde durumu kontrol etmek için
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // RouteObserver ile rotayı dinle
    final ModalRoute? modalRoute = ModalRoute.of(context);
    if (modalRoute != null && modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Widget'ı dispose ederken dinleyiciyi kaldırın
    routeObserver.unsubscribe(this);
    mobileScannerController.stop(); // Kamerayı durdur
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isNavigated) {
      // Geri dönüldüğünde kamera yeniden başlasın
      mobileScannerController.start();
      setState(() {
        _isNavigated = false; // QR kod okuma işlemi tekrar yapılabilsin
      });
    } else if (state == AppLifecycleState.paused) {
      // Uygulama arka plana alındığında kamerayı durdurun
      mobileScannerController.stop();
    }
  }

  @override
  void didPush() {
    // Sayfaya geçiş yapıldığında QR kod okuma işlemini durdur
    mobileScannerController.stop();
  }

  @override
  void didPopNext() {
    // QR sayfasına dönüldüğünde QR okuma işlemini başlat
    mobileScannerController.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: isPermissionGranted
          ? Stack(
              children: [
                MobileScanner(
                  controller: mobileScannerController,
                  onDetect: (BarcodeCapture barcodeCapture) {
                    final Barcode barcode = barcodeCapture.barcodes.first;
                    if (barcode.rawValue != null && !_isNavigated) {
                      setState(() {
                        qrText = barcode.rawValue!;
                        _isNavigated = true; // Bir defa tetiklendikten sonra geçişi durdurur
                      });

                      // QR okunduktan sonra animasyonlu yeni sayfaya geçiş yapıyoruz
                      Navigator.of(context)
                          .push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => QrResultScreen(qrText: qrText),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0); // Alttan üste geçiş
                            const end = Offset.zero;
                            const curve = Curves.ease;
                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      )
                          .then((_) {
                        // Geri dönüldüğünde `_isNavigated` durumunu sıfırlayın
                        setState(() {
                          _isNavigated = false;
                        });
                      });
                    }
                  },
                ),
                // Ortadaki QR okuma çerçevesi
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
                // En üstteki QR kod başlığı
                Positioned(
                  top: context.dynamicHeight(0.05),
                  left: context.dynamicWidth(0.0),
                  right: context.dynamicWidth(0.0),
                  child: Center(
                    child: Text(
                      "QR Kodu Okut",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                // Alttaki Flash Aç/Kapat butonu
                Positioned(
                  bottom: context.dynamicHeight(0.05),
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: toggleFlash, // Flaş aç/kapat işlevi
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFlashOn ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
                        ),
                        child: Icon(
                          isFlashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : isPermissionDenied
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Kamera izni reddedildi. Uygulamayı kullanmak için izin vermelisiniz.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: context.dynamicHeight(0.02)),
                      const ElevatedButton(
                        onPressed: openAppSettings,
                        child: Text('Ayarları Aç'),
                      ),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator()),
    );
  }
}
