/*import 'package:flutter/material.dart';
import 'models/station_data.dart';
import 'models/station_model.dart';

class StationListScreen extends StatelessWidget {
  // StationIp modelini kullanarak verileri eklediyseniz, örneğin bu verileri de burada kullanabilirsiniz.
  // Ancak, eğer `StationIp` verilerini `StationModel` içine dahil ettiyseniz, aşağıdaki listeye gerek kalmayabilir.
  final List<StationIp> stationIps = [
    StationIp(100, 200.0, 'Yes'),
    StationIp(150, 250.5, 'No'),
    StationIp(200, 300.0, 'Yes'),
  ];

  StationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Station List'),
      ),
      body: ListView.builder(
        itemCount: stationModels.length,
        itemBuilder: (context, index) {
          final station = stationModels[index];
          // Eğer StationIp modelini kullanıyorsanız, ilgili veriyi burada kullanabilirsiniz.
          // Ancak, `StationIp` modelinin `StationModel` içinde yer alması daha mantıklı olabilir.
          final stationIp = stationIps[index % stationIps.length]; // Bu kullanım, örnek olması açısından yapılmıştır.
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(station.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Location: ${station.location}'),
                  Text('City: ${station.city}'),
                  Text('Distance: ${station.mesafe} km'),
                  Text('Time Range: ${station.timeRange} hours'),
                  Text('Liked: ${station.like ? 'Yes' : 'No'}'),
                  Text('Suitable: ${station.suitable}'),
                  Text('Coordinates: (${station.x}, ${station.y})'),
                  // StationIp verilerini burada göstermek istiyorsanız, aşağıdaki kodu kullanabilirsiniz:
                  Text('Power: ${stationIp.power} kW'),
                  Text('Price: \$${stationIp.price}'),
                  Text('IP Suitable: ${stationIp.suitable}'),
                ],
              ),
              trailing: Column(
                children: [
                  IconButton(
                    icon: Icon(
                      station.like ? Icons.favorite : Icons.favorite_border,
                      color: station.like ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      // Like button action
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.details),
                    onPressed: () {
                      // Details button action
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
*/