import 'package:evry_app/product/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:evry_app/core/model/charging_station_model.dart';
import 'package:evry_app/product/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class StationDetailsHelper {
  static const Color iconColor = AppColors.iconColor;
  static const Color dislikeColor = AppColors.greyColor;
  static const Color likeColor = AppColors.favoriteColor;
  static Color opacityColor = AppColors.opacityColor;

  // Google Maps'e yönlendiriyor.
  static Future<void> openGoogleMaps(double latitude, double longitude) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void showStationDetails(
    BuildContext context,
    ChargingStationModel station,
    Function(ChargingStationModel) onLikeToggle,
    Future<void> Function(String, bool) saveLike,
    Future<void> Function(ChargingStationModel) saveStation,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.all(context.dynamicWidth(0.05)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: context.dynamicHeight(0.02)),
                  Text(
                    '${station.formattedAddress}, ${station.addressComponents.city}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: context.dynamicHeight(0.02)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: context.dynamicHeight(0.01)),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Text(
                      '${station.addressComponents.city} / ${station.addressComponents.state}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  SizedBox(height: context.dynamicHeight(0.02)),
                  if (station.connectors.isNotEmpty) ...[
                    Text(
                      'Connectors:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: context.dynamicHeight(0.02)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: station.connectors.map((connector) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: context.dynamicHeight(0.01)),
                          child: Text(
                            '${connector.type} - ${connector.kw} kW - ${connector.speed}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: context.dynamicHeight(0.02)),
                  ],
                  if (station.rating != null) ...[
                    Text(
                      'Rating: ${station.rating}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: context.dynamicHeight(0.02)),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              station.like ? Icons.favorite : Icons.favorite_border,
                              color: station.like ? likeColor : dislikeColor,
                            ),
                            onPressed: () async {
                              setState(() {
                                station.like = !station.like;
                              });

                              onLikeToggle(station);
                              await saveLike(station.name, station.like); // Diğer işlemler
                              await saveStation(station);

                              // Favori durumu kalıcı olarak kaydediliyor
                              await StationDetailsHelper.saveLikeStatus(station.name, station.like);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.navigation_outlined, color: AppColors.blueColor),
                            onPressed: () async {
                              await openGoogleMaps(station.latitude, station.longitude);
                            },
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.blue.shade300, width: 1.0),
                        ),
                        onPressed: () {
                          // Show more details or navigate to another screen
                        },
                        child: const Text('Details', style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Favori durumu kaydetmek için
  static Future<void> saveLikeStatus(String stationName, bool isLiked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(stationName, isLiked); // İstasyon ismine göre favori durumu kaydediliyor
  }

  // Favori durumu geri yüklemek için
  static Future<bool> getLikeStatus(String stationName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(stationName) ?? false; // Eğer kayıt yoksa false dönecek
  }
}
