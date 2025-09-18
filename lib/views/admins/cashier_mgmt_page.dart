import 'package:flutter/material.dart';
import 'package:uuid/v4.dart';
import '../../core/services/cashier_services.dart';
import '../../core/models/user.dart';
import '../../core/helpers/constant.dart';
import '../../widgets/ra_text_field.dart';
import '../../widgets/ra_app_bar.dart';

class CashierMgmtPage extends StatefulWidget {
  const CashierMgmtPage({super.key});

  @override
  State<CashierMgmtPage> createState() => _cashierMgmtPageState();
}

class _cashierMgmtPageState extends State<CashierMgmtPage> {
  late Future<List<User>> _list;

  @override
  void _load() {
    _list = CashierServices.index();
    setState(() {});
  }

  void initState() {
    super.initState();
    _load();
  }

  void _addEdit([User? user]) async {
    final name = TextEditingController(text: user?.name ?? '');
    final email = TextEditingController(text: user?.email ?? '');
    final pass = TextEditingController();
    final form = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(user == null ? 'Tambah Kasir' : 'Edit Kasir'),
        content: Form(
          key: form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RATextField(
                  controller: name,
                  label: 'Nama',
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 12),
                RATextField(
                  controller: email,
                  label: 'Email',
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 12),
                RATextField(
                  controller: pass,
                  label: 'Password (Kosongkan jika tidak diubah)',
                  obscure: true,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(_).pop,
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!form.currentState!.validate()) return;
              final newUser = User(
                id: user?.id ?? const UuidV4().generate(),
                name: name.text,
                email: email.text,
                password: pass.text.isEmpty ? user!.password : pass.text,
                role: Constant.roleCashier,
              );
              try {
                user == null
                    ? await CashierServices.create(newUser)
                    : await CashierServices.update(newUser);
                if (!mounted) return;
                Navigator.of(_).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _delete(User user) async {
    await CashierServices.delete(user.id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RAAppBar(title: 'Kelola Kasir'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEdit(),
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<User>>(
        future: _list,
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snap.data ?? [];
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final u = list[i];
              return ListTile(
                title: Text(u.name),
                subtitle: Text(u.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _addEdit(u),
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () => _delete(u),
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
