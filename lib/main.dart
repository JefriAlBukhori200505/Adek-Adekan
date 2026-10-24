import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'models/enums.dart';
import 'screens/driver/driver_shell.dart';
import 'screens/landing_screen.dart';
import 'screens/passenger/passenger_shell.dart';
import 'services/auth_service.dart';
import 'services/chat_service.dart';
import 'services/notification_service.dart';
import 'services/profile_service.dart';
import 'services/ride_order_service.dart';
import 'services/trip_simulator.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Urutan penting: profil harus siap sebelum autentikasi.
  await ProfileService.instance.initialize();
  await AuthService.instance.initialize();
  await NotificationService.instance.initialize();
  await ChatService.instance.initialize();
  await RideOrderService.instance.initialize();

  // Simulator didaftarkan sebelum layar mana pun mendengarkan pesanan.
  TripSimulator.instance.attach();

  runApp(const MojekApp());
}

class MojekApp extends StatelessWidget {
  const MojekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MOJEK',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const AuthGate(),
    );
  }
}

/// Menampilkan beranda sesuai peran bila sudah masuk, atau halaman awal.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthService.instance,
      builder: (context, _) {
        final profile = AuthService.instance.currentProfile;

        if (profile == null) return const LandingScreen();

        return profile.role == UserRole.driver
            ? DriverShell(key: ValueKey(profile.id))
            : PassengerShell(key: ValueKey(profile.id));
      },
    );
  }
}
