import 'package:flutter/material.dart';

import '../../models/enums.dart';
import '../../models/user_profile.dart';
import '../../services/auth_service.dart';
import '../../services/profile_service.dart';
import '../../services/ride_order_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/info_banner.dart';
import '../../widgets/profile_avatar.dart';
import '../../widgets/rating_stars.dart';
import 'edit_profile_screen.dart';
import 'favorites_screen.dart';
import 'notifications_screen.dart';

/// Tab profil untuk penumpang dan driver.
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirmed = await confirmDialog(
      context,
      title: 'Keluar dari akun?',
      message: 'Kamu bisa masuk lagi kapan saja dengan email dan kata sandimu.',
      confirmLabel: 'Keluar',
      destructive: true,
    );

    if (!confirmed || !context.mounted) return;

    Navigator.of(context).popUntil((route) => route.isFirst);
    await AuthService.instance.logout();
  }

  void _open(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        ProfileService.instance,
        RideOrderService.instance,
      ]),
      builder: (context, _) {
        final profile = AuthService.instance.currentProfile;
        if (profile == null) return const SizedBox.shrink();

        final isDriver = profile.role == UserRole.driver;
        final rating = isDriver
            ? RideOrderService.instance.ratingOfDriver(profile.id)
            : (average: 0.0, count: 0);

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 8),
            Center(child: ProfileAvatar.fromProfile(profile, radius: 42)),
            const SizedBox(height: 14),
            Text(
              profile.displayName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${profile.role.label} • ${profile.email}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.secondaryTextColor),
            ),
            if (isDriver) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingStars(value: rating.average, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    rating.count == 0
                        ? 'Belum ada rating'
                        : '${rating.average.toStringAsFixed(1)} (${rating.count})',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 22),
            if (isDriver && !profile.isReadyToDrive) ...[
              InfoBanner(
                icon: Icons.warning_amber_rounded,
                color: AppTheme.warningColor,
                title: 'Lengkapi data kendaraanmu',
                message: 'Nomor HP, motor, dan plat wajib diisi sebelum online.',
                onTap: () => _open(context, EditProfileScreen(profile: profile)),
              ),
              const SizedBox(height: 14),
            ],
            ..._infoTiles(profile),
            const SizedBox(height: 8),
            _MenuTile(
              icon: Icons.edit_outlined,
              title: 'Edit profil',
              onTap: () => _open(context, EditProfileScreen(profile: profile)),
            ),
            if (!isDriver)
              _MenuTile(
                icon: Icons.star_outline_rounded,
                title: 'Lokasi favorit',
                subtitle: '${profile.favorites.length} tersimpan',
                onTap: () => _open(context, const FavoritesScreen()),
              ),
            _MenuTile(
              icon: Icons.notifications_none_rounded,
              title: 'Notifikasi',
              onTap: () => _open(context, const NotificationsScreen()),
            ),
            _MenuTile(
              icon: Icons.info_outline,
              title: 'Tentang MOJEK',
              subtitle: 'Versi prototipe 0.2.0',
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'MOJEK',
                applicationVersion: '0.2.0',
                applicationLegalese: 'Layanan perjalanan untuk mahasiswa.\n'
                    'Peta © OpenStreetMap contributors.',
              ),
            ),
            _MenuTile(
              icon: Icons.logout_rounded,
              title: 'Keluar',
              color: AppTheme.errorColor,
              onTap: () => _logout(context),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _infoTiles(UserProfile profile) {
    String valueOf(String text) => text.trim().isEmpty ? 'Belum diisi' : text;

    if (profile.role == UserRole.driver) {
      return [
        _InfoTile(Icons.phone_outlined, 'Nomor HP', valueOf(profile.phone)),
        _InfoTile(Icons.two_wheeler_rounded, 'Motor',
            valueOf(profile.vehicleModel)),
        _InfoTile(Icons.pin_outlined, 'Plat nomor',
            valueOf(profile.vehiclePlate)),
        _InfoTile(Icons.badge_outlined, 'Nomor SIM',
            valueOf(profile.licenseNumber)),
        const _InfoTile(Icons.verified_user_outlined, 'Verifikasi driver',
            'Belum diverifikasi'),
      ];
    }

    return [
      _InfoTile(Icons.phone_outlined, 'Nomor HP', valueOf(profile.phone)),
      _InfoTile(Icons.school_outlined, 'Kampus', valueOf(profile.campus)),
      _InfoTile(Icons.badge_outlined, 'NIM', valueOf(profile.studentId)),
      _InfoTile(Icons.menu_book_outlined, 'Jurusan', valueOf(profile.major)),
      _InfoTile(
        Icons.verified_user_outlined,
        'Status mahasiswa',
        profile.isStudent ? 'Diskon aktif (belum diverifikasi)' : 'Isi NIM untuk diskon',
      ),
    ];
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile(this.icon, this.title, this.value);

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryLightColor),
        title: Text(title, style: const TextStyle(fontSize: 12)),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.textColor,
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.color = AppTheme.primaryLightColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(
            color: color == AppTheme.errorColor ? color : AppTheme.textColor,
          ),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle!,
                style: const TextStyle(color: AppTheme.secondaryTextColor),
              ),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: AppTheme.secondaryTextColor),
        onTap: onTap,
      ),
    );
  }
}
