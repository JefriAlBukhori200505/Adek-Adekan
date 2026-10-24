/// Validator form yang dipakai bersama.
class Validators {
  Validators._();

  static String? required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi.';
    }
    return null;
  }

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Masukkan alamat email yang valid.';
    }
    return null;
  }

  static String? password(String? value) {
    if ((value ?? '').length < 6) return 'Kata sandi minimal 6 karakter.';
    return null;
  }

  /// Nomor HP Indonesia: 08xx..., 628xx..., atau +628xx...
  static String? phone(String? value) {
    final phone = (value ?? '').replaceAll(RegExp(r'[\s\-]'), '');
    if (!RegExp(r'^(\+62|62|0)8\d{8,11}$').hasMatch(phone)) {
      return 'Nomor HP tidak valid (contoh: 081234567890).';
    }
    return null;
  }

  /// Plat nomor, contoh: BK 1234 AB.
  static String? plate(String? value) {
    final plate = (value ?? '').trim().toUpperCase();
    if (!RegExp(r'^[A-Z]{1,2}\s?\d{1,4}\s?[A-Z]{0,3}$').hasMatch(plate)) {
      return 'Plat nomor tidak valid (contoh: BK 1234 AB).';
    }
    return null;
  }

  /// NIM bersifat opsional; bila diisi harus berupa 5-15 digit.
  static String? optionalStudentId(String? value) {
    final nim = (value ?? '').trim();
    if (nim.isEmpty) return null;
    if (!RegExp(r'^\d{5,15}$').hasMatch(nim)) {
      return 'NIM harus berupa 5-15 angka.';
    }
    return null;
  }
}
