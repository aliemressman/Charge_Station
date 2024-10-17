import 'package:evry_app/core/model/charging_station_model.dart';
import 'package:evry_app/core/model/station_model.dart';
import 'package:evry_app/product/components/appbar/profile_appbar.dart';
import 'package:evry_app/product/constants/text_const.dart';
import 'package:evry_app/product/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

import '../../../../product/constants/colors.dart';
import '../downScreen/home/google_maps_screen.dart';

class NearestStationsScreen extends StatelessWidget {
  // Color Sınıfım
  static Color backGroundBar = AppColors.primaryColor;
  static Color whiteColor = AppColors.whiteColor;
  static Color backGroundColor = AppColors.backgroundColor;
  static Color cardColor = AppColors.cardColor;

  final List<ChargingStationModel> stations;
  final LatLng currentLocation;

  const NearestStationsScreen({super.key, required this.stations, required this.currentLocation});

  @override
  Widget build(BuildContext context) {
    final nearestStations = _getNearestStations();

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ProfileAppbar(title: TextConst.yakinimdakiler),
      ),
      body: Column(
        children: [
          Container(
            color: whiteColor,
            padding: EdgeInsets.only(top: context.dynamicWidth(0.04)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.04)),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Marka Ara',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.borderColor, width: 1.0),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  filled: true,
                  fillColor: cardColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: nearestStations.length,
              itemBuilder: (context, index) {
                final station = nearestStations[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(station.name),
                      subtitle: Text(
                        '${_calculateDistance(currentLocation, LatLng(station.latitude, station.longitude)).toStringAsFixed(2)} km uzaklıkta',
                      ),
                      onTap: () => _navigateToGoogleMaps(context, station),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToGoogleMaps(BuildContext context, ChargingStationModel station) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoogleMapsScreen(
          initialPosition: LatLng(station.latitude, station.longitude),
        ),
      ),
    );
  }

  List<ChargingStationModel> _getNearestStations() {
    List<ChargingStationModel> sortedStations = List.from(stations);
    sortedStations.sort((a, b) {
      final distanceA = _calculateDistance(currentLocation, LatLng(a.latitude, a.longitude));
      final distanceB = _calculateDistance(currentLocation, LatLng(b.latitude, b.longitude));
      return distanceA.compareTo(distanceB);
    });
    return sortedStations.take(3).toList();
  }

  double _calculateDistance(LatLng start, LatLng end) {
    final double lat1 = start.latitude;
    final double lon1 = start.longitude;
    final double lat2 = end.latitude;
    final double lon2 = end.longitude;
    final double dLat = (lat2 - lat1).toRad();
    final double dLon = (lon2 - lon1).toRad();
    final double a = pow(sin(dLat / 2), 2) + cos(lat1.toRad()) * cos(lat2.toRad()) * pow(sin(dLon / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return 6371 * c; // 6371 = Dünya'nın yarıçapı (km)
  }
}

extension on double {
  double toRad() => this * (pi / 180.0);
}
