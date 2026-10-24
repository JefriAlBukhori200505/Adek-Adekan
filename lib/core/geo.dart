import 'package:latlong2/latlong.dart';

const Distance _distance = Distance();

/// Jarak garis lurus antara dua titik, dalam meter.
double distanceMeters(LatLng a, LatLng b) =>
    _distance.as(LengthUnit.Meter, a, b);

/// Kecepatan rata-rata motor di area kampus/kota (m/s), sekitar 20 km/jam.
const double averageSpeedMps = 5.56;

Duration etaFor(double meters) =>
    Duration(seconds: (meters / averageSpeedMps).round());

LatLng lerpLatLng(LatLng a, LatLng b, double t) => LatLng(
      a.latitude + (b.latitude - a.latitude) * t,
      a.longitude + (b.longitude - a.longitude) * t,
    );
