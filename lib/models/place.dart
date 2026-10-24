import 'package:latlong2/latlong.dart';

/// Sebuah titik di peta beserta namanya.
class Place {
  const Place({required this.name, required this.position});

  final String name;
  final LatLng position;

  Map<String, dynamic> toMap() => {
        'name': name,
        'lat': position.latitude,
        'lng': position.longitude,
      };

  factory Place.fromMap(Map<dynamic, dynamic> map) {
    return Place(
      name: map['name'] as String,
      position: LatLng(
        (map['lat'] as num).toDouble(),
        (map['lng'] as num).toDouble(),
      ),
    );
  }
}
