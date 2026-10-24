import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../models/enums.dart';
import '../models/user_profile.dart';
import 'profile_service.dart';

/// Autentikasi LOKAL untuk mode demo.
///
/// Akun dan sesi disimpan di perangkat dengan hash sandi bergaram. Ini
/// cukup untuk prototipe, tetapi bukan pengganti autentikasi server
/// (token, verifikasi email, pembatasan percobaan, dll).
class AuthService extends ChangeNotifier {
  AuthService._();

  @visibleForTesting
  AuthService.forTesting();

  static final AuthService instance = AuthService._();

  Box<dynamic>? _accounts;
  Box<dynamic>? _session;
  String? _currentUserId;

  Future<void> initialize({
    String accountsBox = 'mojek_accounts',
    String sessionBox = 'mojek_session',
  }) async {
    _accounts = await Hive.openBox<dynamic>(accountsBox);
    _session = await Hive.openBox<dynamic>(sessionBox);

    final savedId = _session!.get('userId') as String?;
    if (savedId != null && ProfileService.instance.byId(savedId) != null) {
      _currentUserId = savedId;
    } else {
      _currentUserId = null;
      await _session!.delete('userId');
    }
  }

  bool get isLoggedIn => _currentUserId != null;
  String? get currentUserId => _currentUserId;

  UserProfile? get currentProfile {
    final id = _currentUserId;
    return id == null ? null : ProfileService.instance.byId(id);
  }

  UserRole? get currentRole => currentProfile?.role;

  /// Satu email boleh punya akun penumpang dan akun driver.
  String _key(UserRole role, String email) =>
      '${role.name}|${email.trim().toLowerCase()}';

  String _newSalt() {
    final random = Random.secure();
    return List.generate(16, (_) => random.nextInt(256))
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  String _hash(String salt, String password) =>
      sha256.convert(utf8.encode('$salt:$password')).toString();

  /// Mengembalikan pesan galat, atau null bila berhasil.
  Future<String?> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    final accounts = _accounts;
    final session = _session;
    if (accounts == null || session == null) {
      return 'Penyimpanan belum siap.';
    }

    final key = _key(role, email);
    if (accounts.containsKey(key)) {
      return 'Email ini sudah terdaftar sebagai ${role.label}.';
    }

    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final salt = _newSalt();

    await accounts.put(key, {
      'id': id,
      'salt': salt,
      'hash': _hash(salt, password),
    });

    await ProfileService.instance.save(
      UserProfile(
        id: id,
        role: role,
        email: email.trim().toLowerCase(),
        name: name.trim(),
      ),
    );

    _currentUserId = id;
    await session.put('userId', id);
    notifyListeners();
    return null;
  }

  Future<String?> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final accounts = _accounts;
    final session = _session;
    if (accounts == null || session == null) {
      return 'Penyimpanan belum siap.';
    }

    final account = accounts.get(_key(role, email));
    const wrong = 'Email atau kata sandi salah.';

    if (account is! Map) {
      return 'Akun ${role.label} dengan email ini belum terdaftar.';
    }

    final salt = account['salt'] as String;
    if (_hash(salt, password) != account['hash']) return wrong;

    final id = account['id'] as String;
    if (ProfileService.instance.byId(id) == null) {
      return 'Data profil tidak ditemukan.';
    }

    _currentUserId = id;
    await session.put('userId', id);
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    final id = _currentUserId;
    _currentUserId = null;
    await _session?.delete('userId');

    // Driver otomatis offline saat keluar.
    if (id != null) {
      final profile = ProfileService.instance.byId(id);
      if (profile != null && profile.isOnline) {
        await ProfileService.instance.setOnline(id, false);
      }
    }

    notifyListeners();
  }
}
