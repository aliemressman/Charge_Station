import 'dart:async';
import 'package:evry_app/Ui/views/onboard/downScreen/home/google_maps_screen.dart';
import 'package:evry_app/core/model/charging_station_model.dart';
import 'package:evry_app/product/components/appbar/profile_appbar.dart';
import 'package:evry_app/product/constants/text_const.dart';
import 'package:evry_app/product/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../product/constants/colors.dart';

class SearchPanel extends StatefulWidget {
  final List<ChargingStationModel> stations;

  const SearchPanel({super.key, required this.stations});

  @override
  _SearchPanelState createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {
  static const Color backGroundBar = AppColors.primaryColor;
  static const Color backGroundColor = AppColors.backgroundColor;
  static Color borderColor = AppColors.borderColor;
  static Color cardColor = AppColors.cardColor;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  List<ChargingStationModel> _filteredStations = [];
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _filteredStations = widget.stations;
    _searchController.addListener(_onSearchChanged);
    _getCurrentLocation(); // Kullanıcının mevcut konumunu al
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ProfileAppbar(title: TextConst.istasyonlar),
      ),
      backgroundColor: backGroundColor,
      body: Padding(
        padding: EdgeInsets.all(context.dynamicWidth(0.04)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () {
                      _focusNode.unfocus();
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                  suffixIcon: const Icon(Icons.search),
                  hintText: 'Konum veya İstasyon Ara',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor, width: 1.0),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  filled: true,
                  fillColor: cardColor,
                ),
              ),
            ),
            SizedBox(height: context.dynamicHeight(0.02)),
            Expanded(
              child: Container(
                color: backGroundColor,
                child: ListView.builder(
                  itemCount: _filteredStations.length,
                  itemBuilder: (context, index) {
                    final station = _filteredStations[index];
                    final distance = _calculateDistance(station).toStringAsFixed(2); // Mesafeyi hesapla
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: context.dynamicHeight(0.02)),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                station.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  '${station.addressComponents.streetAddress ?? station.formattedAddress}, ${station.addressComponents.city}'),
                              onTap: () => _navigateToGoogleMaps(context, station),
                              leading: IconButton(
                                icon: const Icon(
                                  Icons.ev_station,
                                  color: backGroundBar,
                                ),
                                onPressed: () => _navigateToGoogleMaps(context, station),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: context.dynamicWidth(0.02), horizontal: context.dynamicWidth(0.04)),
                              child: Text(
                                'Mesafe: $distance km',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _filteredStations = widget.stations
            .where((station) => station.name.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Konum servisi kapalı
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          // Konum izni verilmedi
          return;
        }
      }

      _currentPosition = await Geolocator.getCurrentPosition();
      setState(() {});
    } catch (e) {
      // Hata durumunu ele al
      print('Konum alınamadı: $e');
    }
  }

  double _calculateDistance(ChargingStationModel station) {
    if (_currentPosition == null) return 0.0;

    return Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          station.latitude,
          station.longitude,
        ) /
        1000; // Mesafeyi kilometre cinsinden göster
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
}
