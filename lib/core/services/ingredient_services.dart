import '../models/ingredient.dart';
import '../services/db_services.dart';

class IngredientServices {
  static Future<List<Ingredient>> index() async {
    final db = await DbService.instance.db;
    final maps = await db.query('ingredients', orderBy: 'name');
    return maps.map((m) => Ingredient.fromMap(m)).toList();
  }

  static Future<void> create(Ingredient i) async {
    final db = await DbService.instance.db;
    await db.insert('ingredients', i.toMap());
  }

  static Future<void> update(Ingredient i) async {
    final db = await DbService.instance.db;
    await db.update(
      'ingredients',
      i.toMap(),
      where: 'id = ?',
      whereArgs: [i.id],
    );
  }

  static Future<void> delete(String id) async {
    final db = await DbService.instance.db;
    await db.delete('ingredients', where: 'id = ?', whereArgs: [id]);
  }
}
