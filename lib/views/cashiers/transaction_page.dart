import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_pos/core/providers/auth_providers.dart';
import 'package:resto_pos/core/providers/cart_providers.dart';
import 'package:uuid/v4.dart';
import '../../core/services/printer_services.dart';
import '../../core/helpers/helper.dart';
import '../../widgets/ra_app_bar.dart';
import '../../widgets/ra_text_field.dart';
import '../../core/models/product.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _transactionPageState();
}

class _transactionPageState extends State<TransactionPage> {
  final _table = TextEditingController();
  final _search = TextEditingController();
  String _payment = 'cash';

  @override
  void initState() {
    super.initState();
    _search.addListener(() {
      context.read<CartController>().filter(_search.text);
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _checkout() async {
    if (_table.text.isEmpty || context.read<CartController>().items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meja / Keranjang Kosong')),
      );
      return;
    }

    final cart = context.read<CartController>();
    final auth = context.read<AuthProviders>();
    await cart.checkout(
      table: int.parse(_table.text),
      payment: _payment,
      shift: ShiftHelper.current(),
      cashierId: auth.user!.id,
    );
    if (!mounted) return;

    // printing receipt
    final buffer = StringBuffer();
    buffer.writeln('Resto');
    buffer.writeln('Meja : ${_table.text}');
    buffer.writeln('---------------------');
    for (var item in cart.items) {
      buffer.writeln(
          '${item.product.name} ${item.qty} x ${CurencyHelper.format(item.product.price)}');
    }
    buffer.writeln('---------------------');
    buffer.writeln('Total : ${CurencyHelper.format(cart.total)}');
    buffer.writeln('Bayar : ${_payment.toUpperCase()}');

    try {
      await PrinterServices.printReceipt(buffer.toString());
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Struk Terkirim (Printer Tidak Ditemukan)')),
      );
    }
    _table.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
