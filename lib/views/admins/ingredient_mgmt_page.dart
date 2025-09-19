import 'package:flutter/material.dart';
import 'package:uuid/v4.dart';
import '../../core/services/ingredient_services.dart';
import '../../core/models/ingredient.dart';
import '../../widgets/ra_text_field.dart';
import '../../widgets/ra_app_bar.dart';

class IngredientMgmtPage extends StatefulWidget {
  const IngredientMgmtPage({super.key});

  @override
  State<IngredientMgmtPage> createState() => _ingredientMgmtPageState();
}

class _ingredientMgmtPageState extends State<IngredientMgmtPage> {
  late Future<List<Ingredient>> _list;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _list = IngredientServices.index();
    setState(() {});
  }

  void _addEdit([Ingredient? ingredient]) async {
    final name = TextEditingController(text: ingredient?.name ?? '');
    final stock =
        TextEditingController(text: (ingredient?.stock ?? 0).toString());
    final unit = TextEditingController(text: ingredient?.unit ?? ' pcs');
    final form = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(ingredient == null ? 'Tambah Bahan' : 'Edit Bahan'),
        content: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RATextField(
                controller: name,
                label: 'Nama Bahan',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 12),
              RATextField(
                controller: stock,
                label: 'Stok awal',
                keyboard: TextInputType.number,
              ),
              SizedBox(height: 12),
              RATextField(
                controller: unit,
                label: 'Satuan (ml, gr, pcs)',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: Navigator.of(_).pop, child: Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              if (!form.currentState!.validate()) return;
              final ing = Ingredient(
                id: ingredient?.id ?? const UuidV4().generate(),
                name: name.text,
                stock: int.tryParse(stock.text) ?? 0,
                unit: unit.text,
              );
              ingredient == null
                  ? await IngredientServices.create(ing)
                  : await IngredientServices.update(ing);
              if (!mounted) return;
              Navigator.of(_).pop();
              _load();
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _delete(Ingredient ingredient) async {
    await IngredientServices.delete(ingredient.id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RAAppBar(title: 'Kelola Bahan Baku'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEdit(),
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Ingredient>>(
        future: _list,
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snap.data ?? [];
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final ing = list[i];
              return ListTile(
                title: Text(ing.name),
                subtitle: Text('${ing.stock} ${ing.unit}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () => _addEdit(ing), icon: Icon(Icons.edit)),
                    IconButton(
                        onPressed: () => _delete(ing),
                        icon: Icon(Icons.delete)),
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
