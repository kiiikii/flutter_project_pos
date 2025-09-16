import '../models/expenses.dart';
import '../services/db_services.dart';

class ExpenseServices {
  static Future<List<Expenses>> listByDate(DateTime from, DateTime to) async {
    final db = await DbService.instance.db;
    final maps = await db.rawQuery('''
      SELECT * FROM expenses
      WHERE DATE(createdAt) BETWEEN DATE(?) AND DATE(?)
      ORDER BY createdAt DESC
    ''', [from.toIso8601String(), to.toIso8601String()]);
    return maps.map((m) => Expenses.fromMap((m))).toList();
  }

  static Future<void> create(Expenses exp) async {
    final db = await DbService.instance.db;
    await db.insert('expenses', exp.toMap());
  }
}
