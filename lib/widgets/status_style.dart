import 'package:flutter/material.dart';

import '../models/enums.dart';
import '../theme/app_theme.dart';

/// Warna dan ikon status pesanan, satu tempat untuk semua layar.
extension RideStatusStyle on RideStatus {
  Color get color {
    switch (this) {
      case RideStatus.waiting:
        return AppTheme.warningColor;
      case RideStatus.cancelled:
        return AppTheme.errorColor;
      case RideStatus.accepted:
      case RideStatus.driverOnTheWay:
      case RideStatus.passengerPickedUp:
      case RideStatus.completed:
        return AppTheme.primaryLightColor;
    }
  }

  IconData get icon {
    switch (this) {
      case RideStatus.waiting:
        return Icons.hourglass_top_rounded;
      case RideStatus.accepted:
        return Icons.check_circle_outline_rounded;
      case RideStatus.driverOnTheWay:
        return Icons.two_wheeler_rounded;
      case RideStatus.passengerPickedUp:
        return Icons.route_rounded;
      case RideStatus.completed:
        return Icons.task_alt_rounded;
      case RideStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }
}

extension ServiceTypeStyle on ServiceType {
  IconData get icon =>
      this == ServiceType.priority ? Icons.bolt_rounded : Icons.two_wheeler_rounded;
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.label});

  final RideStatus status;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final color = status.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 17, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label ?? status.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
