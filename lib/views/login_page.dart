import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/auth_providers.dart';
import '../views/admins/admin_dashboard.dart';
import '../views/cashiers/cashier_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _loginPageState();
}

// ignore: camel_case_types
class _loginPageState extends State<LoginPage> {
  final _email = TextEditingController(text: 'admin@resto.com');
  final _pass = TextEditingController(text: '12345');
  final _form = GlobalKey<FormState>();

  void _submit() async {
    if (!_form.currentState!.validate()) return;
    final auth = context.read<AuthProviders>();
    final success = await auth.login(_email.text, _pass.text);
    if (!mounted) return;
    if (success) {
      final user = auth.user!;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => user.role == 'ADMIN'
                ? const AdminDashboard()
                : const CashierDashboard()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Email / Password Salah')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Form(
            key: _form,
            child: Column(
              children: [
                Image.asset('assets/logo.png', height: 120),
                SizedBox(height: 24),
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _pass,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(48)),
                  child: Text('LOGIN'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
