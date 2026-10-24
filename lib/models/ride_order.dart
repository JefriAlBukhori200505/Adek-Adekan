import 'enums.dart';
import 'place.dart';

/// Satu pesanan perjalanan. Objek ini tidak dapat diubah (immutable);
/// perubahan status hanya lewat [RideOrderService] agar aturan terjaga.
class RideOrder {
  const RideOrder({
    required this.id,
    required this.passengerId,
    required this.passengerName,
    required this.pickup,
    required this.destination,
    required this.service,
    required this.payment,
    required this.distanceMeters,
    required this.grossFare,
    required this.discount,
    required this.createdAt,
    this.status = RideStatus.waiting,
    this.driverId,
    this.driverName,
    this.driverVehicle,
    this.driverPlate,
    this.acceptedAt,
    this.completedAt,
    this.cancelledBy,
    this.cancelReason,
    this.rating,
    this.review,
    this.declinedBy = const [],
  });

  final String id;
  final String passengerId;
  final String passengerName;
  final Place pickup;
  final Place destination;
  final ServiceType service;
  final PaymentMethod payment;
  final int distanceMeters;
  final int grossFare;
  final int discount;
  final DateTime createdAt;

  final RideStatus status;
  final String? driverId;
  final String? driverName;
  final String? driverVehicle;
  final String? driverPlate;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final UserRole? cancelledBy;
  final String? cancelReason;
  final int? rating;
  final String? review;

  /// Driver yang menolak/melepas pesanan ini (tidak ditawarkan lagi).
  final List<String> declinedBy;

  /// Tarif akhir setelah diskon.
  int get fare => grossFare - discount;

  bool get hasDriver => driverId != null;
  bool get isRated => rating != null;

  RideOrder copyWith({
    RideStatus? status,
    String? driverId,
    String? driverName,
    String? driverVehicle,
    String? driverPlate,
    DateTime? acceptedAt,
    DateTime? completedAt,
    UserRole? cancelledBy,
    String? cancelReason,
    int? rating,
    String? review,
    List<String>? declinedBy,
    bool clearDriver = false,
  }) {
    return RideOrder(
      id: id,
      passengerId: passengerId,
      passengerName: passengerName,
      pickup: pickup,
      destination: destination,
      service: service,
      payment: payment,
      distanceMeters: distanceMeters,
      grossFare: grossFare,
      discount: discount,
      createdAt: createdAt,
      status: status ?? this.status,
      driverId: clearDriver ? null : (driverId ?? this.driverId),
      driverName: clearDriver ? null : (driverName ?? this.driverName),
      driverVehicle: clearDriver ? null : (driverVehicle ?? this.driverVehicle),
      driverPlate: clearDriver ? null : (driverPlate ?? this.driverPlate),
      acceptedAt: clearDriver ? null : (acceptedAt ?? this.acceptedAt),
      completedAt: completedAt ?? this.completedAt,
      cancelledBy: cancelledBy ?? this.cancelledBy,
      cancelReason: cancelReason ?? this.cancelReason,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      declinedBy: declinedBy ?? this.declinedBy,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'passengerId': passengerId,
        'passengerName': passengerName,
        'pickup': pickup.toMap(),
        'destination': destination.toMap(),
        'service': service.name,
        'payment': payment.name,
        'distanceMeters': distanceMeters,
        'grossFare': grossFare,
        'discount': discount,
        'createdAt': createdAt.toIso8601String(),
        'status': status.name,
        'driverId': driverId,
        'driverName': driverName,
        'driverVehicle': driverVehicle,
        'driverPlate': driverPlate,
        'acceptedAt': acceptedAt?.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'cancelledBy': cancelledBy?.name,
        'cancelReason': cancelReason,
        'rating': rating,
        'review': review,
        'declinedBy': declinedBy,
      };

  factory RideOrder.fromMap(Map<dynamic, dynamic> map) {
    DateTime? parseDate(Object? value) =>
        value is String ? DateTime.tryParse(value) : null;

    final rawCancelledBy = map['cancelledBy'];

    return RideOrder(
      id: map['id'] as String,
      passengerId: map['passengerId'] as String,
      passengerName: (map['passengerName'] as String?) ?? 'Penumpang',
      pickup: Place.fromMap(map['pickup'] as Map),
      destination: Place.fromMap(map['destination'] as Map),
      service: enumByName(ServiceType.values, map['service'], ServiceType.regular),
      payment: enumByName(PaymentMethod.values, map['payment'], PaymentMethod.cash),
      distanceMeters: (map['distanceMeters'] as num).toInt(),
      grossFare: (map['grossFare'] as num).toInt(),
      discount: ((map['discount'] as num?) ?? 0).toInt(),
      createdAt: DateTime.parse(map['createdAt'] as String),
      status: enumByName(RideStatus.values, map['status'], RideStatus.waiting),
      driverId: map['driverId'] as String?,
      driverName: map['driverName'] as String?,
      driverVehicle: map['driverVehicle'] as String?,
      driverPlate: map['driverPlate'] as String?,
      acceptedAt: parseDate(map['acceptedAt']),
      completedAt: parseDate(map['completedAt']),
      cancelledBy: rawCancelledBy == null
          ? null
          : enumByName(UserRole.values, rawCancelledBy, UserRole.passenger),
      cancelReason: map['cancelReason'] as String?,
      rating: (map['rating'] as num?)?.toInt(),
      review: map['review'] as String?,
      declinedBy: (map['declinedBy'] as List?)?.whereType<String>().toList() ??
          const [],
    );
  }
}
