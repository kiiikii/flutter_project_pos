import '../models/product.dart';
import '../services/db_services.dart';

class ProductServices {
  static Future<List<Product>> index() async {
    final db = await DbService.instance.db;
    final maps = await db.query('products', orderBy: 'name');
    return maps.map((m) => Product.fromMap(m)).toList();
  }

  static Future<void> create(Product p) async {
    final db = await DbService.instance.db;
    await db.insert('products', p.toMap());
  }

  static Future<void> update(Product p) async {
    final db = await DbService.instance.db;
    await db.update(
      'products',
      p.toMap(),
      where: 'id = ?',
      whereArgs: [p.id],
    );
  }

  static Future<void> delete(String id) async {
    final db = await DbService.instance.db;
    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
