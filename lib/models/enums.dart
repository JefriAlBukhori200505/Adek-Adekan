/// Mengambil enum dari nama tersimpan; memakai [fallback] bila tidak dikenal.
T enumByName<T extends Enum>(List<T> values, Object? name, T fallback) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  return fallback;
}

enum UserRole {
  passenger('Penumpang'),
  driver('Driver');

  const UserRole(this.label);
  final String label;
}

enum ServiceType {
  regular(
    label: 'Reguler',
    description: 'Perjalanan hemat untuk mahasiswa',
    baseFare: 5000,
    perKm: 2000,
  ),
  priority(
    label: 'Prioritas',
    description: 'Pesananmu ditampilkan lebih dulu ke driver',
    baseFare: 8000,
    perKm: 3000,
  );

  const ServiceType({
    required this.label,
    required this.description,
    required this.baseFare,
    required this.perKm,
  });

  final String label;
  final String description;

  /// Tarif dasar (rupiah).
  final int baseFare;

  /// Tarif per kilometer (rupiah).
  final int perKm;
}

enum PaymentMethod {
  cash('Tunai', 'Bayar langsung ke driver'),
  wallet('E-Wallet (simulasi)', 'Belum terhubung ke penyedia pembayaran');

  const PaymentMethod(this.label, this.description);
  final String label;
  final String description;
}

enum RideStatus {
  waiting('Menunggu driver'),
  accepted('Driver menerima pesanan'),
  driverOnTheWay('Driver menuju lokasi jemput'),
  passengerPickedUp('Perjalanan berlangsung'),
  completed('Perjalanan selesai'),
  cancelled('Pesanan dibatalkan');

  const RideStatus(this.label);
  final String label;

  /// Sudah dipegang driver dan masih berjalan.
  bool get isActive =>
      this == accepted || this == driverOnTheWay || this == passengerPickedUp;

  /// Belum selesai/dibatalkan (menunggu atau berjalan).
  bool get isOpen => this == waiting || isActive;

  bool get isFinished => this == completed || this == cancelled;

  /// Tahap berikutnya yang boleh dijalankan driver.
  RideStatus? get next {
    switch (this) {
      case accepted:
        return driverOnTheWay;
      case driverOnTheWay:
        return passengerPickedUp;
      case passengerPickedUp:
        return completed;
      case waiting:
      case completed:
      case cancelled:
        return null;
    }
  }
}
