import 'package:flutter/material.dart';

import '../../models/place.dart';
import '../../services/auth_service.dart';
import '../../services/profile_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/empty_state.dart';
import 'location_picker_screen.dart';

/// Lokasi favorit penumpang (kos, rumah, dll).
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  static const int maxFavorites = 5;

  Future<void> _add(BuildContext context) async {
    final profile = AuthService.instance.currentProfile;
    if (profile == null) return;

    if (profile.favorites.length >= maxFavorites) {
      showSnack(context, 'Maksimal $maxFavorites lokasi favorit.', error: true);
      return;
    }

    final place = await Navigator.push<Place>(
      context,
      MaterialPageRoute(
        builder: (_) => const LocationPickerScreen(
          title: 'Tambah lokasi favorit',
        ),
      ),
    );

    if (place == null) return;

    await ProfileService.instance.save(
      profile.copyWith(favorites: [...profile.favorites, place]),
    );
  }

  Future<void> _remove(int index) async {
    final profile = AuthService.instance.currentProfile;
    if (profile == null || index >= profile.favorites.length) return;

    final updated = [...profile.favorites]..removeAt(index);
    await ProfileService.instance.save(profile.copyWith(favorites: updated));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lokasi Favorit')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.textColor,
        onPressed: () => _add(context),
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Tambah'),
      ),
      body: ListenableBuilder(
        listenable: ProfileService.instance,
        builder: (context, _) {
          final favorites = AuthService.instance.currentProfile?.favorites ??
              const <Place>[];

          if (favorites.isEmpty) {
            return const EmptyState(
              icon: Icons.star_outline_rounded,
              title: 'Belum ada favorit',
              message:
                  'Simpan lokasi seperti kos atau rumah agar pesan '
                  'perjalanan lebih cepat.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: favorites.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final place = favorites[index];

              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: ListTile(
                  leading: const Icon(Icons.star_rounded,
                      color: AppTheme.warningColor),
                  title: Text(place.name),
                  subtitle: Text(
                    '${place.position.latitude.toStringAsFixed(5)}, '
                    '${place.position.longitude.toStringAsFixed(5)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                  trailing: IconButton(
                    tooltip: 'Hapus',
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: AppTheme.errorColor),
                    onPressed: () => _remove(index),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
