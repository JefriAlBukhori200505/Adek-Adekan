import 'package:flutter/material.dart';

import '../../core/validators.dart';
import '../../models/enums.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/mojek_button.dart';

/// Masuk atau daftar untuk satu peran. Setelah berhasil, AuthGate di
/// main.dart otomatis menampilkan beranda sesuai peran.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.role});

  final UserRole role;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _registerMode = false;
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final navigator = Navigator.of(context);
    setState(() {
      _loading = true;
      _error = null;
    });

    final auth = AuthService.instance;
    final error = _registerMode
        ? await auth.register(
            email: _email.text,
            password: _password.text,
            name: _name.text,
            role: widget.role,
          )
        : await auth.login(
            email: _email.text,
            password: _password.text,
            role: widget.role,
          );

    if (!mounted) return;

    if (error != null) {
      setState(() {
        _loading = false;
        _error = error;
      });
      return;
    }

    // Gerbang login sudah menampilkan beranda; tutup layar ini.
    navigator.popUntil((route) => route.isFirst);
  }

  void _toggleMode() {
    setState(() {
      _registerMode = !_registerMode;
      _error = null;
    });
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      );

  @override
  Widget build(BuildContext context) {
    final isDriver = widget.role == UserRole.driver;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        isDriver
                            ? Icons.two_wheeler_rounded
                            : Icons.person_rounded,
                        color: AppTheme.primaryLightColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _registerMode
                          ? 'Daftar sebagai ${widget.role.label}'
                          : 'Masuk sebagai ${widget.role.label}',
                      style: const TextStyle(
                          fontSize: 27, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _registerMode
                          ? 'Buat akun MOJEK barumu.'
                          : 'Gunakan email untuk masuk ke akun MOJEK.',
                      style: const TextStyle(
                        color: AppTheme.secondaryTextColor,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    if (_registerMode) ...[
                      _label('Nama lengkap'),
                      TextFormField(
                        controller: _name,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'Nama kamu',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) => Validators.required(v, 'Nama'),
                      ),
                      const SizedBox(height: 20),
                    ],
                    _label('Email'),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'nama@email.com',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 20),
                    _label('Kata sandi'),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscure,
                      autofillHints: const [AutofillHints.password],
                      textInputAction: _registerMode
                          ? TextInputAction.next
                          : TextInputAction.done,
                      onFieldSubmitted: (_) {
                        if (!_registerMode) _submit();
                      },
                      decoration: InputDecoration(
                        hintText: 'Minimal 6 karakter',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          tooltip: _obscure
                              ? 'Tampilkan kata sandi'
                              : 'Sembunyikan kata sandi',
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: Validators.password,
                    ),
                    if (_registerMode) ...[
                      const SizedBox(height: 20),
                      _label('Ulangi kata sandi'),
                      TextFormField(
                        controller: _confirm,
                        obscureText: _obscure,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        decoration: const InputDecoration(
                          hintText: 'Ketik ulang kata sandi',
                          prefixIcon: Icon(Icons.lock_outline_rounded),
                        ),
                        validator: (v) => v != _password.text
                            ? 'Kata sandi tidak sama.'
                            : null,
                      ),
                    ],
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: const TextStyle(color: AppTheme.errorColor),
                      ),
                    ],
                    const SizedBox(height: 28),
                    MojekButton(
                      label: _registerMode ? 'Daftar' : 'Masuk',
                      icon: Icons.arrow_forward_rounded,
                      isLoading: _loading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: _loading ? null : _toggleMode,
                        child: Text(
                          _registerMode
                              ? 'Sudah punya akun? Masuk'
                              : 'Belum punya akun? Daftar',
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Mode prototipe: akun disimpan di perangkat ini dan '
                        'belum terhubung ke server.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.secondaryTextColor,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
