import 'package:evry_app/Ui/views/onboard/rightScreen/nearest_stations_screen.dart';
import 'package:evry_app/Ui/views/onboard/upScreen/filtre/view/filter_screen.dart';
import 'package:evry_app/Ui/views/onboard/upScreen/search/search_panel.dart';
import 'package:evry_app/core/model/charging_station_model.dart';
import 'package:evry_app/core/service/station_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsFunction {
  final ChargingStationService _chargingStationService =
      ChargingStationService();

  // Arama panelini göstermek için
  Future<void> showSearchPanel(BuildContext context) async {
    List<ChargingStationModel> stations =
        await _chargingStationService.fetchChargingStations();

    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: SearchPanel(stations: stations),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    ));
  }

  // Filtre ekranını göstermek için
  showFilterScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const FilterScreen();
      },
    );
  }

  // En yakın istasyonları göstermek için
  showNearestStations(
      BuildContext context, List<ChargingStationModel> stations) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NearestStationsScreen(
          stations: stations,
          currentLocation: const LatLng(
              41.01971580000506, 28.889406977912), // YTÜ Davutpaşa Yıldızpark
        ),
      ),
    );
  }
}
