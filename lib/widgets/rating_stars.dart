import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Bintang rating. Bila [onChanged] diisi, bintang bisa diketuk.
class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 20,
  });

  final double value;
  final ValueChanged<int>? onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final filled = value >= index + 0.75;
        final half = !filled && value >= index + 0.25;

        final icon = Icon(
          filled
              ? Icons.star_rounded
              : half
                  ? Icons.star_half_rounded
                  : Icons.star_outline_rounded,
          size: size,
          color: AppTheme.warningColor,
        );

        if (onChanged == null) return icon;

        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => onChanged!(index + 1),
          child: Padding(padding: const EdgeInsets.all(2), child: icon),
        );
      }),
    );
  }
}
