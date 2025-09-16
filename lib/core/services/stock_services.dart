import '../models/stock_movement.dart';
import '../services/db_services.dart';

class StockServices {
  static Future<List<StockMovement>> listByDate(
      DateTime from, DateTime to) async {
    final db = await DbService.instance.db;
    final maps = await db.rawQuery('''
      SELECT sm.*, i.name as ingredientName
      FROM stock_movements sm
      JOIN ingredients i ON i.id = sm.ingredientId
      WHERE DATE(sm.createdAt) BETWEEN DATE(?) AND DATE(?)
      ORDER BY sm.cratedAt DESC
    ''', [from.toIso8601String(), to.toIso8601String()]);
    return maps.map((m) => StockMovement.fromMap(m)).toList();
  }

  static Future<void> create(StockMovement sm) async {
    final db = await DbService.instance.db;
    await db.insert('stock_movements', sm.toMap());
  }
}
