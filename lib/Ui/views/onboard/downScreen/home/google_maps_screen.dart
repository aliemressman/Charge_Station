import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:evry_app/Ui/views/onboard/downScreen/home/station_detail_helper.dart';
import 'package:evry_app/Ui/views/onboard/downScreen/home/storage/station_storage.dart';
import 'package:evry_app/Ui/views/onboard/downScreen/notifications/notifications_screen.dart';
import 'package:evry_app/Ui/views/onboard/downScreen/operations/operations_screen.dart';
import 'package:evry_app/Ui/views/onboard/downScreen/profile/mainProfile/profile_view.dart';
import 'package:evry_app/Ui/views/onboard/downScreen/qr/view/qr_screen.dart';
import 'package:evry_app/core/model/charging_station_model.dart';
import 'package:evry_app/core/service/station_service.dart';
import 'package:evry_app/product/extensions/context_extension.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../product/constants/sized_box_area.dart';
import '../../rightScreen/nearest_stations_screen.dart';
import '../../rightScreen/save_station.dart';
import '../../upScreen/filtre/view/filter_screen.dart';
import '../../upScreen/search/search_panel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends StatefulWidget {
  final LatLng? initialPosition;
  final VoidCallback? onMapLoaded;

  const GoogleMapsScreen({
    super.key,
    this.initialPosition,
    this.onMapLoaded,
  });

  @override
  _GoogleMapsScreenState createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  late final LatLng initialPosition;
  ChargingStationModel? selectedStation;

  final ChargingStationService _chargingStationService = ChargingStationService();
  List<ChargingStationModel> stations =
      []; // Tüm istasyonları içeren bir liste, loadlikestatus fonksiyonunda doldurulacak

  BitmapDescriptor? customMarkerIcon;
  MapType _mapType = MapType.normal;
  GoogleMapController? _mapController;

  final List<ChargingStationModel> _stations = [];
  List<Marker> markers = [];

  final SizedBoxArea sizedBoxArea = SizedBoxArea();

  @override
  void initState() {
    super.initState();
    _loadCustomMarkerIcon();
    _loadMarkers();
    _loadLikeStatus();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showFilterScreen() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const FilterScreen();
      },
    );
  }

  Future<bool> _getLikeStatus(String stationName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(stationName) ?? false;
  }

  Future<void> _loadLikeStatus() async {
    for (var station in _stations) {
      station.like = await _getLikeStatus(station.name);
    }
    setState(() {});
  }

  Future<void> _saveLike(String stationName, bool like) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(stationName, like);
  }

  Future<void> _loadCustomMarkerIcon() async {
    customMarkerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/mark_icon.png',
    );
  }

  Future<void> _loadMarkers() async {
    List<ChargingStationModel> stations = await _chargingStationService.fetchChargingStations();
    setState(() {
      _stations.addAll(stations);
      markers = stations.map((station) {
        return Marker(
          markerId: MarkerId(station.id),
          position: LatLng(station.latitude, station.longitude),
          infoWindow: InfoWindow(
            title: station.name,
            snippet: station.addressComponents.city,
          ),
          icon: customMarkerIcon ?? BitmapDescriptor.defaultMarker,
          onTap: () => _showStationDetails(station),
        );
      }).toList();

      if (selectedStation != null) {
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(selectedStation!.latitude, selectedStation!.longitude),
            15.0,
          ),
        );
      }
    });
  }

  Future<void> _showSearchPanel() async {
    List<ChargingStationModel> stations = await _chargingStationService.fetchChargingStations();

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
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    ));
  }

  Future<void> _saveStation(ChargingStationModel station) async {
    List<ChargingStationModel> savedStations = await StationStorage.loadStations();
    if (station.like) {
      savedStations.add(station);
    } else {
      savedStations.removeWhere((s) => s.id == station.id);
    }
    await StationStorage.saveStations(savedStations);
  }

  // Kaydedilen istasyonları göstermek için

  void _showSaveStation() {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: SaveStation(
            stations: _stations,
            onRemove: (station) {
              setState(() {
                _stations.remove(station);
              });
              _saveStation(station);
            },
          ),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    ));
  }

  void _showStationDetails(ChargingStationModel station) {
    StationDetailsHelper.showStationDetails(
      context,
      station,
      (updatedStation) {
        setState(() {
          station.like =
              updatedStation.like; // Güncellenen modelin like değerini burada doğrudan model üzerinden güncelliyoruz
        });
      },
      _saveLike,
      _saveStation,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (widget.onMapLoaded != null) {
      widget.onMapLoaded!();
    }
    _loadMarkers();
  }

  void _toggleMapType() {
    setState(() {
      if (_mapType == MapType.normal) {
        _mapType = MapType.satellite;
      } else {
        _mapType = MapType.normal;
      }
    });
    if (_mapController != null) {
      _mapController!.setMapStyle(_mapType == MapType.satellite
          ? '[{"featureType": "all","elementType": "geometry","stylers": [{"saturation": -100},{"lightness": 30}]}]'
          : null);
    }
  }

  Future<void> _showCurrentLocation() async {
    try {
      // Konum servisi kontrolü
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Kullanıcıyı ayarlara yönlendir
        await Geolocator.openLocationSettings();
        return;
      }

      // Konum izni kontrolü
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          // Kullanıcı izni vermedi
          return;
        }
      }

      // Mevcut konumu al
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      LatLng currentLocation = LatLng(position.latitude, position.longitude);

      if (_mapController != null) {
        // Haritayı mevcut konuma yakınlaştır
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            currentLocation,
            15.0, // Zoom seviyesi
          ),
        );

        // Önceki marker'ı kaldır ve yeni marker ekle
        setState(() {
          markers.removeWhere((m) => m.markerId.value == 'current_location');
          markers.add(
            Marker(
              markerId: const MarkerId('current_location'),
              position: currentLocation,
              infoWindow: const InfoWindow(
                title: 'Mevcut Konum',
              ),
            ),
          );
        });
      }
    } catch (e) {
      // Hata mesajı
      print('Mevcut konum alınamadı: $e');
    }
  }

  void _showNearestStations() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NearestStationsScreen(
          stations: _stations,
          currentLocation: const LatLng(41.01971580000506, 28.889406977912), // YTÜ Davutpaşa Yıldızpark
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Google Maps Screen
          Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: widget.initialPosition ?? const LatLng(41.01971580000506, 28.889406977912),
                  zoom: 14,
                ),
                zoomControlsEnabled: false,
                onMapCreated: _onMapCreated,
                mapType: _mapType,
                markers: Set<Marker>.of(markers),
              ),
              Padding(
                padding: EdgeInsets.all(context.dynamicWidth(0.04)),
                child: Column(
                  children: [
                    SizedBox(height: context.dynamicHeight(0.05)),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            onTap: _showSearchPanel,
                            decoration: InputDecoration(
                              hintText: 'Konum/İstasyon Ara',
                              hintStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.7),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.white),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: context.dynamicWidth(0.02), horizontal: context.dynamicWidth(0.02)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _showFilterScreen,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(context.dynamicWidth(0.02)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(context.dynamicWidth(0.03)),
                              child: const Icon(Icons.filter_alt, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: context.dynamicHeight(0.2)),
                            _buildkonumkaydedilen(Icons.my_location, _showCurrentLocation),
                            SizedBox(height: context.dynamicHeight(0.02)),
                            GestureDetector(
                              onTap: _showNearestStations,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(context.dynamicWidth(0.02)),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.list, color: Colors.white),
                                  onPressed: _showNearestStations,
                                ),
                              ),
                            ),
                            SizedBox(height: context.dynamicHeight(0.02)),
                            _buildkonumkaydedilen(Icons.bookmark, _showSaveStation),
                            SizedBox(height: context.dynamicHeight(0.02)),
                            GestureDetector(
                              onTap: _toggleMapType,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(context.dynamicWidth(0.02)),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.map_outlined, color: Colors.white),
                                  onPressed: _toggleMapType,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Diğer sayfalar
          const OperationsScreen(),
          const QrScreen(),
          const NotificationsScreen(),
          const ProfileView(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.home, size: context.dynamicHeight(0.04)),
          Icon(Icons.access_time, size: context.dynamicHeight(0.04)),
          Icon(Icons.qr_code, size: context.dynamicHeight(0.04)),
          Icon(Icons.notifications, size: context.dynamicHeight(0.04)),
          Icon(Icons.person, size: context.dynamicHeight(0.04)),
        ],
        color: const Color.fromARGB(98, 158, 158, 158),
        buttonBackgroundColor: Colors.grey[200],
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 200),
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildkonumkaydedilen(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(context.dynamicWidth(0.02)),
        ),
        child: IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
