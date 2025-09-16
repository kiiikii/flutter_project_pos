import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/auth_providers.dart';
import '../widgets/ra_text_field.dart';
import '../widgets/ra_app_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _profilePageState();
}

class _profilePageState extends State<ProfilePage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _passCtrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProviders>().user!;
    _nameCtrl = TextEditingController(text: user.name);
    _emailCtrl = TextEditingController(text: user.email);
    _passCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  /* ---------------- SAVE ---------------- */
  void _save() async {
    // TODO: update password in DB
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProviders>();
    try {
      await auth.updateProfile(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        newPassword: _passCtrl.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data Sudah diperbaharui')));
      _passCtrl.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal : $e')));
    }
  }

  /* ---------------- LOGOUT ---------------- */
  void _logout() {
    context.read<AuthProviders>().logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  /* ---------------- UI ---------------- */
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProviders>().user!;
    return Scaffold(
      appBar: RAAppBar(title: 'Profile'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /* ---------------- ROLE BADGE ---------------- */
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Theme.of(context).primaryColor.withOpacity(.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  user.role.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 24),

              /* ----- NAME ----- */
              RATextField(
                controller: _nameCtrl,
                label: 'Nama',
                validator: (v) => v!.isEmpty ? 'Wajib Diisi' : null,
              ),
              SizedBox(height: 16),

              /* ----- EMAIL ----- */
              RATextField(
                controller: _emailCtrl,
                label: 'Email',
                validator: (v) {
                  if (v!.isEmpty) return 'Wajib Diisi';
                  if (!v.contains('@')) return 'Email Tidak Valid';
                  return null;
                },
              ),
              SizedBox(height: 16),

              /* ----- PASSWORD ----- */
              RATextField(
                controller: _passCtrl,
                label: 'Passowrd (Kosongkan jika tidak berubah)',
                obscure: true,
              ),
              SizedBox(height: 32),

              /* ----- SAVE ----- */
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  label: Text('SIMPAN PERUBAHAN'),
                  icon: Icon(Icons.save),
                ),
              ),
              SizedBox(height: 12),

              /* ----- LOGOUT ----- */
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _logout,
                  label: Text('LOGOUT'),
                  icon: Icon(Icons.logout),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
