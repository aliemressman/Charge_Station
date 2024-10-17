import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evry_app/core/model/charging_station_model.dart';

class StationStorage {
  static const String _savedStationsKey = 'saved_stations';

  // İstasyonları kaydet
  static Future<void> saveStations(List<ChargingStationModel> stations) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> stationsJson = stations.map((station) => jsonEncode(station.toJson())).toList();
    await prefs.setStringList(_savedStationsKey, stationsJson);
  }

  // İstasyonları oku
  static Future<List<ChargingStationModel>> loadStations() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? stationsJson = prefs.getStringList(_savedStationsKey);
    if (stationsJson == null) return [];
    return stationsJson.map((stationJson) => ChargingStationModel.fromJson(jsonDecode(stationJson))).toList();
  }

  // Belirli bir istasyonu sil
  static Future<void> removeStation(String stationId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? stationsJson = prefs.getStringList(_savedStationsKey);
    if (stationsJson == null) return;

    final List<ChargingStationModel> stations =
        stationsJson.map((stationJson) => ChargingStationModel.fromJson(jsonDecode(stationJson))).toList();

    stations.removeWhere((station) => station.id == stationId);

    final List<String> updatedStationsJson = stations.map((station) => jsonEncode(station.toJson())).toList();
    await prefs.setStringList(_savedStationsKey, updatedStationsJson);
  }
}
