import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/auth_providers.dart';
import '../views/login_page.dart';
import '../widgets/ra_text_field.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProviders>();
    final user = auth.user!;
    final name = TextEditingController(text: user.name);
    final pass = TextEditingController();

    void _save() async {
      // TODO: update password in DB
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data Sudah diperbaharui')));
    }

    void _logout() {
      auth.logout();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    }

    return Scaffold();
  }
}
