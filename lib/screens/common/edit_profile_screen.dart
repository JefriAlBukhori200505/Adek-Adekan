import 'package:flutter/material.dart';

import '../../core/validators.dart';
import '../../models/enums.dart';
import '../../models/user_profile.dart';
import '../../services/profile_service.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/mojek_button.dart';
import '../../widgets/profile_avatar.dart';

/// Edit profil untuk penumpang dan driver (field menyesuaikan peran).
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  final UserProfile profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final _email = TextEditingController(text: widget.profile.email);
  late final _name = TextEditingController(text: widget.profile.name);
  late final _phone = TextEditingController(text: widget.profile.phone);
  late final _campus = TextEditingController(text: widget.profile.campus);
  late final _studentId = TextEditingController(text: widget.profile.studentId);
  late final _major = TextEditingController(text: widget.profile.major);
  late final _vehicleModel =
      TextEditingController(text: widget.profile.vehicleModel);
  late final _vehiclePlate =
      TextEditingController(text: widget.profile.vehiclePlate);
  late final _license =
      TextEditingController(text: widget.profile.licenseNumber);

  bool _saving = false;

  bool get _isDriver => widget.profile.role == UserRole.driver;

  @override
  void dispose() {
    for (final controller in [
      _email,
      _name,
      _phone,
      _campus,
      _studentId,
      _major,
      _vehicleModel,
      _vehiclePlate,
      _license,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final updated = widget.profile.copyWith(
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      campus: _campus.text.trim(),
      studentId: _studentId.text.trim(),
      major: _major.text.trim(),
      vehicleModel: _vehicleModel.text.trim(),
      vehiclePlate: _vehiclePlate.text.trim().toUpperCase(),
      licenseNumber: _license.text.trim(),
    );

    await ProfileService.instance.save(updated);
    if (!mounted) return;

    showSnack(context, 'Profil berhasil disimpan.');
    Navigator.pop(context);
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    String? hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextCapitalization capitalization = TextCapitalization.words,
    int? maxLength,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: keyboardType,
            textCapitalization: capitalization,
            maxLength: maxLength,
            validator: validator,
            decoration: InputDecoration(hintText: hint, counterText: ''),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: ProfileAvatar(
                  name: _name.text.isEmpty ? widget.profile.displayName : _name.text,
                  radius: 40,
                ),
              ),
              const SizedBox(height: 24),
              _field(
                'Email',
                _email,
                readOnly: true,
                capitalization: TextCapitalization.none,
              ),
              _field(
                'Nama lengkap',
                _name,
                hint: 'Nama sesuai identitas',
                maxLength: 60,
                validator: (v) => Validators.required(v, 'Nama'),
              ),
              _field(
                'Nomor HP',
                _phone,
                hint: '081234567890',
                keyboardType: TextInputType.phone,
                capitalization: TextCapitalization.none,
                maxLength: 16,
                validator: Validators.phone,
              ),
              if (_isDriver) ...[
                _field(
                  'Merek & tipe motor',
                  _vehicleModel,
                  hint: 'Contoh: Honda Beat 2021',
                  maxLength: 40,
                  validator: (v) => Validators.required(v, 'Data motor'),
                ),
                _field(
                  'Plat nomor',
                  _vehiclePlate,
                  hint: 'BK 1234 AB',
                  capitalization: TextCapitalization.characters,
                  maxLength: 12,
                  validator: Validators.plate,
                ),
                _field(
                  'Nomor SIM C (opsional)',
                  _license,
                  keyboardType: TextInputType.number,
                  capitalization: TextCapitalization.none,
                  maxLength: 16,
                ),
              ] else ...[
                _field('Kampus', _campus, hint: 'Nama kampus', maxLength: 60),
                _field(
                  'NIM (untuk diskon mahasiswa)',
                  _studentId,
                  keyboardType: TextInputType.number,
                  capitalization: TextCapitalization.none,
                  maxLength: 15,
                  validator: Validators.optionalStudentId,
                ),
                _field('Jurusan', _major, maxLength: 60),
              ],
              const SizedBox(height: 4),
              MojekButton(
                label: 'Simpan Perubahan',
                icon: Icons.check_rounded,
                isLoading: _saving,
                onPressed: _save,
              ),
              const SizedBox(height: 12),
              const Text(
                'Data masih tersimpan di perangkat ini dan belum diverifikasi.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.white54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
