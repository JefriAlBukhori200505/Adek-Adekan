import 'package:flutter/material.dart';

import '../models/enums.dart';
import '../theme/app_theme.dart';
import '../widgets/mojek_button.dart';
import 'auth/auth_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void _open(BuildContext context, UserRole role) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => AuthScreen(role: role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.two_wheeler_rounded,
                      size: 36,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'MOJEK',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Teman perjalanan mahasiswa.',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Transportasi yang praktis, terjangkau, '
                    'dan dirancang untuk lingkungan kampus.',
                    style: TextStyle(
                      height: 1.6,
                      fontSize: 14,
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.school_rounded,
                            color: AppTheme.primaryLightColor, size: 28),
                        SizedBox(height: 12),
                        Text(
                          'Mobilitas khusus mahasiswa',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Pesan perjalanan dengan diskon mahasiswa, atau '
                          'ambil pesanan sesuai jadwal kuliahmu.',
                          style: TextStyle(
                            height: 1.5,
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  MojekButton(
                    label: 'Masuk sebagai Penumpang',
                    icon: Icons.person_rounded,
                    onPressed: () => _open(context, UserRole.passenger),
                  ),
                  const SizedBox(height: 12),
                  MojekButton(
                    label: 'Masuk sebagai Driver',
                    icon: Icons.two_wheeler_rounded,
                    style: MojekButtonStyle.outlined,
                    onPressed: () => _open(context, UserRole.driver),
                  ),
                  const SizedBox(height: 22),
                  const Center(
                    child: Text(
                      'MOJEK • Teman jalan anak kampus',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
