import 'package:uuid/v4.dart';
import 'package:flutter/material.dart';
import '../../core/services/expense_services.dart';
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
    final exp = Expense();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
