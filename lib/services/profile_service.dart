import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../models/enums.dart';
import '../models/user_profile.dart';

/// Menyimpan profil penumpang dan driver di perangkat.
class ProfileService extends ChangeNotifier {
  ProfileService._();

  @visibleForTesting
  ProfileService.forTesting();

  static final ProfileService instance = ProfileService._();

  Box<dynamic>? _box;
  final Map<String, UserProfile> _profiles = {};

  Future<void> initialize({String boxName = 'mojek_profiles'}) async {
    _box = await Hive.openBox<dynamic>(boxName);
    _profiles.clear();

    for (final value in _box!.values) {
      if (value is Map) {
        try {
          final profile = UserProfile.fromMap(value);
          _profiles[profile.id] = profile;
        } catch (error) {
          debugPrint('Profil tersimpan tidak dapat dibaca: $error');
        }
      }
    }
  }

  UserProfile? byId(String id) => _profiles[id];

  List<UserProfile> get onlineDrivers => _profiles.values
      .where((p) => p.role == UserRole.driver && p.isOnline)
      .toList();

  Future<void> save(UserProfile profile) async {
    final box = _box;
    if (box == null) throw StateError('ProfileService belum diinisialisasi.');

    _profiles[profile.id] = profile;
    await box.put(profile.id, profile.toMap());
    notifyListeners();
  }

  Future<void> setOnline(String id, bool online) async {
    final profile = _profiles[id];
    if (profile == null) return;
    await save(profile.copyWith(isOnline: online));
  }
}
