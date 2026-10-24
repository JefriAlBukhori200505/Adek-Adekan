String formatRupiah(int amount) {
  final negative = amount < 0;
  final digits = amount.abs().toString();
  final buffer = StringBuffer();

  for (var i = 0; i < digits.length; i++) {
    buffer.write(digits[i]);
    final remaining = digits.length - i - 1;
    if (remaining > 0 && remaining % 3 == 0) buffer.write('.');
  }

  return '${negative ? '-' : ''}Rp$buffer';
}

const List<String> _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];

const List<String> _weekdays = [
  'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min',
];

String _two(int value) => value.toString().padLeft(2, '0');

String formatTime(DateTime date) => '${_two(date.hour)}:${_two(date.minute)}';

String formatDate(DateTime date) =>
    '${_two(date.day)} ${_months[date.month - 1]} ${date.year}';

String formatDateTime(DateTime date) =>
    '${formatDate(date)} • ${formatTime(date)}';

String formatWeekday(DateTime date) => _weekdays[date.weekday - 1];

String formatDistance(num meters) {
  if (meters < 1000) return '${meters.round()} m';
  return '${(meters / 1000).toStringAsFixed(1)} km';
}

String formatEta(Duration duration) {
  final minutes =
      duration.inSeconds <= 60 ? 1 : (duration.inSeconds / 60).ceil();
  return '$minutes mnt';
}

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
