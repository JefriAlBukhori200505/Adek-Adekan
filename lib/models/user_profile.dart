import 'enums.dart';
import 'place.dart';

/// Profil pengguna untuk penumpang maupun driver.
class UserProfile {
  const UserProfile({
    required this.id,
    required this.role,
    required this.email,
    required this.name,
    this.phone = '',
    this.campus = '',
    this.studentId = '',
    this.major = '',
    this.vehicleModel = '',
    this.vehiclePlate = '',
    this.licenseNumber = '',
    this.isOnline = false,
    this.favorites = const [],
  });

  final String id;
  final UserRole role;
  final String email;
  final String name;
  final String phone;

  // Penumpang
  final String campus;
  final String studentId;
  final String major;
  final List<Place> favorites;

  // Driver
  final String vehicleModel;
  final String vehiclePlate;
  final String licenseNumber;
  final bool isOnline;

  /// Penumpang yang mengisi NIM berhak atas diskon mahasiswa.
  bool get isStudent => studentId.trim().isNotEmpty;

  /// Data minimum agar driver boleh menerima pesanan.
  bool get isReadyToDrive =>
      name.trim().isNotEmpty &&
      phone.trim().isNotEmpty &&
      vehicleModel.trim().isNotEmpty &&
      vehiclePlate.trim().isNotEmpty;

  String get displayName => name.trim().isEmpty ? 'Pengguna MOJEK' : name.trim();

  String get initials {
    final parts = displayName.split(RegExp(r'\s+'));
    final first = parts.first.isNotEmpty ? parts.first[0] : '?';
    final second = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    return '$first$second'.toUpperCase();
  }

  UserProfile copyWith({
    String? name,
    String? phone,
    String? campus,
    String? studentId,
    String? major,
    String? vehicleModel,
    String? vehiclePlate,
    String? licenseNumber,
    bool? isOnline,
    List<Place>? favorites,
  }) {
    return UserProfile(
      id: id,
      role: role,
      email: email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      campus: campus ?? this.campus,
      studentId: studentId ?? this.studentId,
      major: major ?? this.major,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      isOnline: isOnline ?? this.isOnline,
      favorites: favorites ?? this.favorites,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'role': role.name,
        'email': email,
        'name': name,
        'phone': phone,
        'campus': campus,
        'studentId': studentId,
        'major': major,
        'vehicleModel': vehicleModel,
        'vehiclePlate': vehiclePlate,
        'licenseNumber': licenseNumber,
        'isOnline': isOnline,
        'favorites': favorites.map((place) => place.toMap()).toList(),
      };

  factory UserProfile.fromMap(Map<dynamic, dynamic> map) {
    final rawFavorites = map['favorites'];

    return UserProfile(
      id: map['id'] as String,
      role: enumByName(UserRole.values, map['role'], UserRole.passenger),
      email: map['email'] as String,
      name: (map['name'] as String?) ?? '',
      phone: (map['phone'] as String?) ?? '',
      campus: (map['campus'] as String?) ?? '',
      studentId: (map['studentId'] as String?) ?? '',
      major: (map['major'] as String?) ?? '',
      vehicleModel: (map['vehicleModel'] as String?) ?? '',
      vehiclePlate: (map['vehiclePlate'] as String?) ?? '',
      licenseNumber: (map['licenseNumber'] as String?) ?? '',
      isOnline: (map['isOnline'] as bool?) ?? false,
      favorites: rawFavorites is List
          ? rawFavorites
              .whereType<Map>()
              .map((item) => Place.fromMap(item))
              .toList()
          : const [],
    );
  }
}
