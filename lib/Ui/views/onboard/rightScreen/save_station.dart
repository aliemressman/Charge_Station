import 'package:evry_app/core/model/charging_station_model.dart';
import 'package:evry_app/product/components/appbar/profile_appbar.dart';
import 'package:evry_app/product/constants/text_const.dart';
import 'package:flutter/material.dart';
import '../../../../product/constants/colors.dart';
import '../downScreen/home/station_detail_helper.dart';
import '../downScreen/home/storage/station_storage.dart';

class SaveStation extends StatefulWidget {
  final List<ChargingStationModel> stations;
  final void Function(ChargingStationModel) onRemove;

  const SaveStation({super.key, required this.stations, required this.onRemove});

  @override
  _SaveStationState createState() => _SaveStationState();
}

class _SaveStationState extends State<SaveStation> {
  @override
  void initState() {
    super.initState();
    _loadSavedStations();
  }

  Future<void> _loadSavedStations() async {
    List<ChargingStationModel> savedStations = await StationStorage.loadStations();
    setState(() {
      widget.stations.addAll(savedStations.where((station) => station.like));
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ChargingStationModel> savedStations = widget.stations.where((station) => station.like).toList();

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ProfileAppbar(title: TextConst.kaydedilen),
      ),
      body: savedStations.isEmpty
          ? const Center(child: Text('Kaydedilmiş hiç istasyon yok'))
          : ListView.builder(
              itemCount: savedStations.length,
              itemBuilder: (context, index) {
                final station = savedStations[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(station.name),
                      subtitle: Text('${station.addressComponents.state} / ${station.addressComponents.city}'),
                      trailing: IconButton(
                        icon: Icon(
                          station.like ? Icons.favorite : Icons.favorite_border,
                          color: station.like ? AppColors.favoriteColor : AppColors.greyColor,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.onRemove(station); // İstasyonu kaydedilenlerden çıkarıyoruz
                          });
                          _removeStation(station);
                        },
                      ),
                      leading: const Icon(
                        Icons.ev_station,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _removeStation(ChargingStationModel station) async {
    // SharedPreferences'tan istasyonu kaldır
    await StationStorage.removeStation(station.id);

    // Ekrandaki listeden istasyonu kaldır
    setState(() {
      widget.stations.remove(station);
    });

    // Favori durumunu güncelle
    await StationDetailsHelper.saveLikeStatus(station.name, false);
  }
}
