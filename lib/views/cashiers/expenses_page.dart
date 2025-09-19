import 'package:provider/provider.dart';
import 'package:uuid/v4.dart';
import 'package:flutter/material.dart';
import '../../core/services/expense_services.dart';
import '../../core/providers/auth_providers.dart';
import '../../core/models/expenses.dart';
import '../../core/helpers/helper.dart';
import '../../widgets/ra_text_field.dart';
import '../../widgets/ra_app_bar.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _expensesPageState();
}

class _expensesPageState extends State<ExpensesPage> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  final _form = GlobalKey<FormState>();

  /* ------- SAVE ------- */
  void _save() async {
    if (!_form.currentState!.validate()) return;

    final auth = context.read<AuthProviders>();
    final exp = Expenses(
      id: const UuidV4().generate(),
      cashierId: auth.user!.id,
      amount: CurencyHelper.toInt(double.parse(_amount.text)),
      note: _note.text,
      shiftType: ShiftHelper.current(),
      createdAt: DateTime.now(),
    );

    await ExpenseServices.create(exp);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pengeluaran Tersimpan (tidak bisa diubah)')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RAAppBar(title: 'Input Pengeluaran'),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              RATextField(
                controller: _amount,
                label: 'Jumlah (Rp)',
                keyboard: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 12),
              RATextField(
                controller: _note,
                label: 'Keterangan',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
