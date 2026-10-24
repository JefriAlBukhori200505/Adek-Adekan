import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum MojekButtonStyle { filled, outlined, danger }

class MojekButton extends StatelessWidget {
  const MojekButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.style = MojekButtonStyle.filled,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final MojekButtonStyle style;

  @override
  Widget build(BuildContext context) {
    final callback = isLoading ? null : onPressed;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    );

    final Widget content = isLoading
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppTheme.textColor,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 19),
                const SizedBox(width: 9),
              ],
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    final Widget button;

    switch (style) {
      case MojekButtonStyle.filled:
        button = ElevatedButton(onPressed: callback, child: content);
      case MojekButtonStyle.outlined:
        button = OutlinedButton(
          onPressed: callback,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primaryLightColor,
            side: const BorderSide(color: AppTheme.primaryColor),
            shape: shape,
            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          child: content,
        );
      case MojekButtonStyle.danger:
        button = OutlinedButton(
          onPressed: callback,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.errorColor,
            side: BorderSide(
              color: AppTheme.errorColor.withValues(alpha: 0.7),
            ),
            shape: shape,
            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          child: content,
        );
    }

    return SizedBox(width: double.infinity, height: 52, child: button);
  }
}
