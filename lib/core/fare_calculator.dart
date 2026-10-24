import '../models/enums.dart';

class FareQuote {
  const FareQuote({
    required this.distanceMeters,
    required this.grossFare,
    required this.discount,
  });

  /// Jarak perkiraan lewat jalan (meter).
  final int distanceMeters;

  /// Tarif sebelum diskon.
  final int grossFare;

  /// Potongan diskon mahasiswa (0 bila tidak berlaku).
  final int discount;

  int get total => grossFare - discount;
}

/// Perhitungan tarif berdasarkan jarak.
///
/// Jarak garis lurus dikalikan [roadFactor] sebagai pendekatan jarak jalan.
/// Bila nanti ada layanan routing, ganti masukan jaraknya saja.
class FareCalculator {
  FareCalculator._();

  static const double roadFactor = 1.3;
  static const double studentDiscountRate = 0.10;
  static const int roundingStep = 500;

  static FareQuote quote({
    required double straightLineMeters,
    required ServiceType service,
    required bool studentDiscount,
  }) {
    final roadMeters = straightLineMeters * roadFactor;
    final raw = service.baseFare + (roadMeters / 1000) * service.perKm;
    final gross = (raw / roundingStep).ceil() * roundingStep;

    final discount = studentDiscount
        ? ((gross * studentDiscountRate) / 100).round() * 100
        : 0;

    return FareQuote(
      distanceMeters: roadMeters.round(),
      grossFare: gross,
      discount: discount,
    );
  }
}
