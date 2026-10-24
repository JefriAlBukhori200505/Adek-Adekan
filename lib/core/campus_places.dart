import 'package:latlong2/latlong.dart';

import '../models/place.dart';
import 'geo.dart';

class CampusPlaces {
  CampusPlaces._();

  static final LatLng center = LatLng(-6.2000, 106.8166);

  static final List<Place> all = [
    Place(name: 'Gerbang Utama', position: LatLng(-6.2000, 106.8166)),
    Place(name: 'Perpustakaan Pusat', position: LatLng(-6.2012, 106.8178)),
    Place(name: 'Fakultas Teknik', position: LatLng(-6.2025, 106.8160)),
    Place(name: 'Fakultas Ekonomi', position: LatLng(-6.1988, 106.8185)),
    Place(name: 'Kantin Pusat', position: LatLng(-6.2006, 106.8150)),
    Place(name: 'Asrama Mahasiswa', position: LatLng(-6.2035, 106.8190)),
    Place(name: 'Halte Kampus', position: LatLng(-6.1995, 106.8140)),
  ];

  /// Lokasi kampus terdekat dalam radius [withinMeters], atau null.
  static Place? nearest(LatLng point, {double withinMeters = 80}) {
    Place? best;
    var bestDistance = withinMeters;

    for (final place in all) {
      final d = distanceMeters(point, place.position);
      if (d <= bestDistance) {
        best = place;
        bestDistance = d;
      }
    }

    return best;
  }
}
