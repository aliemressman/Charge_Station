class ChargingStationModel {
  final String id;
  final String name;
  final List<Connector> connectors;
  final String formattedAddress;
  final AddressComponents addressComponents;
  final double latitude;
  final double longitude;
  final String? placeLink;
  final String? phoneNumber;
  final OpeningHours openingHours;
  final double? rating;
  final int? reviewCount;
  final String? website;
  final String? photo;
  final String googlePlaceId;
  final String googleCid;
  bool like = false;

  ChargingStationModel({
    required this.id,
    required this.name,
    required this.connectors,
    required this.formattedAddress,
    required this.addressComponents,
    required this.latitude,
    required this.longitude,
    this.placeLink,
    this.phoneNumber,
    required this.openingHours,
    this.rating,
    this.reviewCount,
    this.website,
    this.photo,
    required this.googlePlaceId,
    required this.googleCid,
    this.like = false, // Varsayılan değer
  });

  factory ChargingStationModel.fromJson(Map<String, dynamic> json) {
    return ChargingStationModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      connectors: (json['connectors'] as List<dynamic>?)
              ?.map((connector) =>
                  Connector.fromJson(connector as Map<String, dynamic>))
              .toList() ??
          [],
      formattedAddress: json['formatted_address'] ?? '',
      addressComponents:
          AddressComponents.fromJson(json['address_components'] ?? {}),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      placeLink: json['place_link'],
      phoneNumber: json['phone_number'],
      openingHours: OpeningHours.fromJson(json['opening_hours'] ?? {}),
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['review_count'] as int?,
      website: json['website'],
      photo: json['photo'],
      googlePlaceId: json['google_place_id'] ?? '',
      googleCid: json['google_cid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'connectors': connectors.map((e) => e.toJson()).toList(),
        'formatted_address': formattedAddress,
        'address_components': addressComponents.toJson(),
        'latitude': latitude,
        'longitude': longitude,
        'place_link': placeLink,
        'phone_number': phoneNumber,
        'opening_hours': openingHours.toJson(),
        'rating': rating,
        'review_count': reviewCount,
        'website': website,
        'photo': photo,
        'google_place_id': googlePlaceId,
        'google_cid': googleCid,
        'like': like,
      };
}

class Connector {
  final String type;
  final int total;
  final int? available;
  final int kw;
  final String speed;

  Connector({
    required this.type,
    required this.total,
    this.available,
    required this.kw,
    required this.speed,
  });

  factory Connector.fromJson(Map<String, dynamic> json) {
    return Connector(
      type: json['type'] ?? '',
      // String olarak gelen değerleri int'e çeviriyoruz
      total: int.tryParse(json['total'].toString()) ?? 0,
      available: json['available'] != null
          ? int.tryParse(json['available'].toString())
          : null,
      kw: int.tryParse(json['kw'].toString()) ?? 0,
      speed: json['speed'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'total': total,
        'available': available,
        'kw': kw,
        'speed': speed,
      };
}

class AddressComponents {
  final String district;
  final String? streetAddress;
  final String city;
  final String zipcode;
  final String state;
  final String country;

  AddressComponents({
    required this.district,
    this.streetAddress,
    required this.city,
    required this.zipcode,
    required this.state,
    required this.country,
  });

  factory AddressComponents.fromJson(Map<String, dynamic> json) {
    return AddressComponents(
      district: json['district'] ?? '',
      streetAddress: json['street_address'],
      city: json['city'] ?? '',
      zipcode: json['zipcode'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'district': district,
        'street_address': streetAddress,
        'city': city,
        'zipcode': zipcode,
        'state': state,
        'country': country,
      };
}

class OpeningHours {
  final Map<String, List<String>> hours;

  OpeningHours({
    required this.hours,
  });

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    final hours = <String, List<String>>{};
    json.forEach((key, value) {
      hours[key] = List<String>.from(value);
    });
    return OpeningHours(hours: hours);
  }

  Map<String, dynamic> toJson() =>
      hours.map((key, value) => MapEntry(key, value));
}
