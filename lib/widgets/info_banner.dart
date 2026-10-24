import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Banner informasi/aksi, mis. "Perjalanan sedang aktif".
class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.onTap,
    this.color = AppTheme.primaryLightColor,
  });

  final IconData icon;
  final String title;
  final String? message;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.tintSurfaceColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (message != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        message!,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.secondaryTextColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
