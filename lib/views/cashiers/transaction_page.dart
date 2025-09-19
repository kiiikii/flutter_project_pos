import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_pos/core/providers/auth_providers.dart';
import 'package:resto_pos/core/providers/cart_providers.dart';
import '../../core/services/printer_services.dart';
import '../../core/helpers/helper.dart';
import '../../widgets/ra_app_bar.dart';
import '../../widgets/ra_text_field.dart';

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
    return Scaffold(
      appBar: RAAppBar(title: 'Transaksi'),
      body: Row(
        children: [
          // LEFT : product grid + search
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _search,
                    decoration: InputDecoration(
                      hintText: 'Cari Produk',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Consumer<CartController>(
                      builder: (_, cart, __) => GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: cart.filteredProducts.length,
                        itemBuilder: (_, i) {
                          final p = cart.filteredProducts[i];
                          return Card(
                            child: InkWell(
                              onTap: () => cart.add(p),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      p.name,
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(p.priceLabel,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // RIGHT : cart + table + pay
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade100,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  RATextField(
                    controller: _table,
                    label: 'Nomor Meja',
                    keyboard: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Consumer<CartController>(
                      builder: (_, cart, __) => ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (_, i) {
                          final item = cart.items[i];
                          return ListTile(
                            title: Text(item.product.name),
                            subtitle: Text(
                                '${item.qty} x ${item.product.priceLabel}'),
                            trailing: IconButton(
                              onPressed: () => cart.remove(item),
                              icon: Icon(Icons.delete),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text('Total :', style: TextStyle(fontSize: 20)),
                      Spacer(),
                      Consumer<CartController>(
                        builder: (_, cart, __) => Text(
                          CurencyHelper.format(cart.total),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _payment,
                    items: ['cash', 'e-wallet', 'bank transfer']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _payment = v!),
                    decoration: InputDecoration(labelText: 'Pembayaran'),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _checkout,
                      child: Text('Bayar & Cetak'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
