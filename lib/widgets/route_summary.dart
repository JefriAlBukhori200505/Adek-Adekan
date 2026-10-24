import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Tampilan jemput → tujuan dengan garis penghubung.
class RouteSummary extends StatelessWidget {
  const RouteSummary({
    super.key,
    required this.pickup,
    required this.destination,
  });

  final String pickup;
  final String destination;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row(Icons.circle, AppTheme.primaryLightColor, 'Jemput', pickup, 13),
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 16,
              width: 2,
              margin: const EdgeInsets.symmetric(vertical: 4),
              color: AppTheme.borderColor,
            ),
          ),
        ),
        _row(Icons.location_on_rounded, AppTheme.errorColor, 'Tujuan',
            destination, 14),
      ],
    );
  }

  Widget _row(
    IconData icon,
    Color color,
    String label,
    String value,
    double iconSize,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: iconSize, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.35,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
