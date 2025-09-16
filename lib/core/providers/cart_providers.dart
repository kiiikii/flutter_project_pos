import 'package:flutter/foundation.dart';
import 'package:uuid/v4.dart';
import '../models/product.dart';
import '../models/transaction.dart';
import '../services/db_services.dart';

class CartProviders {
  final Product product;
  int qty;
  CartProviders({required this.product, this.qty = 1});
}

class CartController with ChangeNotifier {
  final List<CartProviders> _items = [];
  final List<Product> _products = [];
  // ignore: prefer_final_fields
  String _filter = '';

  List<CartProviders> get items => _items;
  List<Product> get filteredProducts => _products
      .where((p) => p.name.toLowerCase().contains(_filter.toLowerCase()))
      .toList();
  int get total => _items.fold(0, (sum, e) => sum + (e.product.price * e.qty));

  CartController() {
    _loadProducts();
  }

  void _loadProducts() async {
    final db = await DbService.instance.db;
    final maps = await db.query('products');
    _products.clear();
    _products.addAll(maps.map((m) => Product.fromMap(m)).toList());
    notifyListeners();
  }

  void filter(String query) {
    _filter = query;
    notifyListeners();
  }

  void add(Product p) {
    final idx = _items.indexWhere((i) => i.product.id == p.id);
    if (idx >= 0) {
      _items[idx].qty++;
    } else {
      _items.add(CartProviders(product: p));
    }
    notifyListeners();
  }

  void remove(CartProviders item) {
    _items.remove(item);
    notifyListeners();
  }

  Future<void> checkout({
    required int table,
    required String payment,
    required String shift,
    required String cashierId,
  }) async {
    final db = await DbService.instance.db;
    final tx = Transaction(
      id: const UuidV4().generate(),
      cashierId: cashierId,
      tableNumber: table,
      items: _serializeItems(),
      total: total,
      paymentMethod: payment,
      shiftType: shift,
      createdAt: DateTime.now(),
    );
    await db.insert('transactions', tx.toMap());
    _items.clear();
    notifyListeners();
  }

  String _serializeItems() {
    return _items
        .map((i) =>
            '{"id":"${i.product.id}","name":"${i.product.name}","qty":${i.qty},"price":${i.product.price}}')
        .join(',');
  }
}
