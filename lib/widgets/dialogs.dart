import 'package:flutter/material.dart';

import '../services/ride_order_service.dart';
import '../theme/app_theme.dart';
import 'mojek_button.dart';
import 'rating_stars.dart';

void showSnack(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? AppTheme.errorColor : AppTheme.surfaceColor,
      ),
    );
}

Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Ya',
  String cancelLabel = 'Batal',
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppTheme.surfaceColor,
      title: Text(title),
      content: Text(
        message,
        style: const TextStyle(color: AppTheme.secondaryTextColor, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(cancelLabel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(0, 44),
            backgroundColor:
                destructive ? AppTheme.errorColor : AppTheme.primaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );

  return result ?? false;
}

/// Meminta alasan (pembatalan/pelepasan pesanan). Null bila ditutup.
Future<String?> showReasonSheet(
  BuildContext context, {
  required String title,
  required List<String> reasons,
  required String confirmLabel,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppTheme.surfaceColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (sheetContext) => _ReasonSheet(
      title: title,
      reasons: reasons,
      confirmLabel: confirmLabel,
    ),
  );
}

class _ReasonSheet extends StatefulWidget {
  const _ReasonSheet({
    required this.title,
    required this.reasons,
    required this.confirmLabel,
  });

  final String title;
  final List<String> reasons;
  final String confirmLabel;

  @override
  State<_ReasonSheet> createState() => _ReasonSheetState();
}

class _ReasonSheetState extends State<_ReasonSheet> {
  static const String _other = 'Lainnya';

  final TextEditingController _otherController = TextEditingController();
  String? _selected;

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  String? get _reason {
    if (_selected == null) return null;
    if (_selected == _other) {
      final text = _otherController.text.trim();
      return text.isEmpty ? null : text;
    }
    return _selected;
  }

  @override
  Widget build(BuildContext context) {
    final options = [...widget.reasons, _other];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            for (final option in options)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  _selected == option
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: _selected == option
                      ? AppTheme.primaryLightColor
                      : AppTheme.secondaryTextColor,
                ),
                title: Text(option),
                onTap: () => setState(() => _selected = option),
              ),
            if (_selected == _other) ...[
              const SizedBox(height: 4),
              TextField(
                controller: _otherController,
                maxLength: 120,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(hintText: 'Tulis alasanmu'),
              ),
            ],
            const SizedBox(height: 12),
            MojekButton(
              label: widget.confirmLabel,
              style: MojekButtonStyle.danger,
              onPressed: _reason == null
                  ? null
                  : () => Navigator.pop(context, _reason),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sheet rating. Mengembalikan true bila rating berhasil disimpan.
Future<bool> showRatingSheet(
  BuildContext context, {
  required String orderId,
  required String passengerId,
  required String driverName,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppTheme.surfaceColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) => _RatingSheet(
      orderId: orderId,
      passengerId: passengerId,
      driverName: driverName,
    ),
  );

  return result ?? false;
}

class _RatingSheet extends StatefulWidget {
  const _RatingSheet({
    required this.orderId,
    required this.passengerId,
    required this.driverName,
  });

  final String orderId;
  final String passengerId;
  final String driverName;

  @override
  State<_RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends State<_RatingSheet> {
  final TextEditingController _reviewController = TextEditingController();
  int _rating = 0;
  String? _error;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submit() {
    final error = RideOrderService.instance.rateOrder(
      widget.orderId,
      widget.passengerId,
      _rating,
      review: _reviewController.text,
    );

    if (error != null) {
      setState(() => _error = error);
      return;
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        24,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Bagaimana perjalananmu?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Beri nilai untuk ${widget.driverName}',
              style: const TextStyle(color: AppTheme.secondaryTextColor),
            ),
            const SizedBox(height: 16),
            RatingStars(
              value: _rating.toDouble(),
              size: 38,
              onChanged: (value) => setState(() {
                _rating = value;
                _error = null;
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _reviewController,
              maxLength: 200,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Tulis ulasan (opsional)',
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _error!,
                  style: const TextStyle(color: AppTheme.errorColor),
                ),
              ),
            const SizedBox(height: 4),
            MojekButton(
              label: 'Kirim Rating',
              icon: Icons.star_rounded,
              onPressed: _rating == 0 ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
