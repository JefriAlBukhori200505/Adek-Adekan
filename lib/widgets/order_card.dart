import 'package:flutter/material.dart';

import '../core/formatters.dart';
import '../models/ride_order.dart';
import '../theme/app_theme.dart';
import 'route_summary.dart';
import 'status_style.dart';

/// Kartu pesanan yang dipakai di riwayat penumpang, daftar pesanan masuk
/// driver, dan daftar pendapatan.
class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.showStatus = true,
    this.subtitle,
    this.footer,
    this.badge,
  });

  final RideOrder order;
  final VoidCallback? onTap;
  final bool showStatus;

  /// Menggantikan tanggal di bawah judul.
  final String? subtitle;

  /// Teks kiri di bagian bawah; default nama driver.
  final String? footer;

  /// Label kecil di kanan atas (mis. PRIORITAS).
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surfaceColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.tintColor,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      order.service.icon,
                      color: AppTheme.primaryLightColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MOJEK ${order.service.label}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle ?? formatDateTime(order.createdAt),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.tintSurfaceColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryLightColor,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              RouteSummary(
                pickup: order.pickup.name,
                destination: order.destination.name,
              ),
              if (showStatus) ...[
                const SizedBox(height: 14),
                StatusChip(status: order.status),
              ],
              const SizedBox(height: 14),
              const Divider(color: AppTheme.borderColor, height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      footer ?? order.driverName ?? 'Belum ada driver',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatRupiah(order.fare),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryLightColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
