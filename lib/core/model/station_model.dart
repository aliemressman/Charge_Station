/*class StationModel {
  String name;
  String location;
  String city;
  int mesafe;
  double timeRange;
  bool like;
  String suitable;
  double latitude;
  double longitude;
  double power;
  double price;
  double distanceEnYakin;

  StationModel(
    this.name,
    this.location,
    this.city,
    this.mesafe,
    this.timeRange,
    this.like,
    this.suitable,
    this.latitude,
    this.longitude,
    this.distanceEnYakin,
    this.power,
    this.price,
  );

  // JSON dönüşüm fonksiyonları
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'city': city,
      'mesafe': mesafe,
      'timeRange': timeRange,
      'like': like,
      'suitable': suitable,
      'latitude': latitude,
      'longitude': longitude,
      'distanceEnYakin': distanceEnYakin,
      'power': power,
      'price': price,
    };
  }

  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      json['name'],
      json['location'],
      json['city'],
      json['mesafe'],
      json['timeRange'],
      json['like'],
      json['suitable'],
      json['latitude'],
      json['longitude'],
      json['distanceEnYakin'],
      json['power'],
      json['price'],
    );
  }
}

class StationIp {
  int power;
  double price;
  String suitable;

  StationIp(this.power, this.price, this.suitable);

  // JSON dönüşüm fonksiyonları
  Map<String, dynamic> toJson() {
    return {
      'power': power,
      'price': price,
      'suitable': suitable,
    };
  }

  factory StationIp.fromJson(Map<String, dynamic> json) {
    return StationIp(
      json['power'],
      json['price'],
      json['suitable'],
    );
  }
}

class Connector {
  String type;
  int total;
  int available;
  double kw;

  Connector({
    required this.type,
    required this.total,
    required this.available,
    required this.kw,
  });

  // JSON dönüşüm fonksiyonları
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'total': total,
      'available': available,
      'kw': kw,
    };
  }

  factory Connector.fromJson(Map<String, dynamic> json) {
    return Connector(
      type: json['type'],
      total: json['total'],
      available: json['available'],
      kw: json['kw'],
    );
  }
}
*/