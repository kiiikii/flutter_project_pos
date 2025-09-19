import 'package:flutter/material.dart';
import 'package:resto_pos/core/services/ingredient_services.dart';
import 'package:resto_pos/core/services/product_services.dart';
import 'package:uuid/v4.dart';
import '../../core/models/product.dart';
import '../../core/models/ingredient.dart';
import '../../core/helpers/helper.dart';
import '../../widgets/ra_app_bar.dart';
import '../../widgets/ra_text_field.dart';

class ProductMgmtPage extends StatefulWidget {
  const ProductMgmtPage({super.key});

  @override
  State<ProductMgmtPage> createState() => _ProductMgmtPageState();
}

class _ProductMgmtPageState extends State<ProductMgmtPage> {
  late Future<List<Product>> _products;
  late Future<List<Ingredient>> _ingredients;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _products = ProductServices.index();
    _ingredients = IngredientServices.index();
    setState(() {});
  }

  void _addEdit([Product? product]) async {
    final name = TextEditingController(text: product?.name ?? '');
    final price = TextEditingController(
        text: product == null ? '' : (product.price / 100).toStringAsFixed(0));
    final qty =
        TextEditingController(text: product?.qtyNeeded.toString() ?? '0');
    String cat = product?.category ?? 'food';
    String? ingId = product?.ingredientId;

    final form = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (ctx, setStateDiag) {
        return AlertDialog(
          title: Text(product == null ? 'Tambah Produk' : 'Edit Produk'),
          content: Form(
            key: form,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RATextField(
                    controller: name,
                    label: 'Nama Produk',
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  RATextField(
                    controller: price,
                    label: 'Harga (Rp)',
                    keyboard: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: cat,
                    items: ['food', 'beverage', 'snack']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setStateDiag(() => cat = v!),
                    decoration: const InputDecoration(labelText: 'Kategori'),
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<List<Ingredient>>(
                    future: _ingredients,
                    builder: (_, snap) {
                      final list = snap.data ?? [];
                      return DropdownButtonFormField<String?>(
                        value: ingId,
                        items: <DropdownMenuItem<String?>>[
                              const DropdownMenuItem(
                                  child: Text('Tanpa Bahan'), value: null)
                            ] +
                            list
                                .map<DropdownMenuItem<String?>>(
                                  (i) => DropdownMenuItem(
                                      value: i.id, child: Text(i.name)),
                                )
                                .toList(),
                        decoration:
                            const InputDecoration(labelText: 'Bahan Baku'),
                        onChanged: (v) => setStateDiag(() => ingId = v),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  RATextField(
                    controller: qty,
                    label: 'Qty bahan yang dibutuhkan',
                    keyboard: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: Navigator.of(_).pop, child: const Text('Batal')),
            ElevatedButton(
              onPressed: () async {
                if (!form.currentState!.validate()) return;
                final p = Product(
                  id: product?.id ?? const UuidV4().generate(),
                  name: name.text,
                  price: CurencyHelper.toInt(double.parse(price.text)),
                  category: cat,
                  ingredientId: ingId,
                  qtyNeeded: int.tryParse(qty.text) ?? 0,
                );
                product == null
                    ? await ProductServices.create(p)
                    : await ProductServices.update(p);
                if (!mounted) return;
                Navigator.of(_).pop();
                _load();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      }),
    );
  }

  void _delete(Product product) async {
    await ProductServices.delete(product.id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RAAppBar(title: 'Kelola Produk'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEdit(),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Product>>(
        future: _products,
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snap.data ?? [];
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final p = list[i];
              return ListTile(
                title: Text(p.name),
                subtitle: Text('${p.category} – ${p.priceLabel}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _addEdit(p)),
                    IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _delete(p)),
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
