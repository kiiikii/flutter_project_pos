import 'package:resto_pos/core/services/db_services.dart';

import 'expense_services.dart';
import 'stock_services.dart';

/// Aggregated data for charts / PDF
class ReportServices {
  /* ------------------ SALES ------------------ */
  static Future<List<Map<String, dynamic>>> sales(
      DateTime from, DateTime to) async {
    final db = await DbService.instance.db;
    return db.rawQuery('''
        SELECT shift_type, DATE(createdAt) as date, SUM(total) as total
        FROM transactions
        WHERE DATE(createdAt) BETWEEN DATE(?) AND DATE(?)
        GROUP BY shift_type, DATE(createdAt)
        ORDER BY date
    ''', [from.toIso8601String(), to.toIso8601String()]);
  }

  /* ------------------ EXPENSES ------------------ */
  static Future<List<Map<String, dynamic>>> expenses(
      DateTime from, DateTime to) async {
    final data = await ExpenseServices.listByDate(from, to);
    return data
        .map((e) => {
              'date': e.createdAt.toIso8601String().substring(0, 10),
              'shift_type': e.shiftType,
              'total': e.amount
            })
        .toList();
  }

  /* ------------------ STOCK ------------------ */
  static Future<List<Map<String, dynamic>>> stock(
      DateTime from, DateTime to) async {
    final data = await StockServices.listByDate(from, to);
    return data
        .map((e) => {
              'date': e.createdAt.toIso8601String().substring(0, 10),
              'ingredent': e.ingredientId,
              'type': e.type,
              'qty': e.qty,
            })
        .toList();
  }
}
