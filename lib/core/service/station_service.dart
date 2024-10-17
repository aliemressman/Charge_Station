import 'dart:convert';
import 'package:evry_app/core/model/charging_station_model.dart';
import 'package:http/http.dart' as http;

class ChargingStationService {
  // Şarj istasyonlarını API'den çekmek için fonksiyon
  Future<List<ChargingStationModel>> fetchChargingStations() async {
    final response = await http.get(Uri.parse(
        'https://run.mocky.io/v3/3e95ae5e-732f-4fb9-982f-856684da7447')); // URL'yi burada belirleyin

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => ChargingStationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load charging stations');
    }
  }
}
