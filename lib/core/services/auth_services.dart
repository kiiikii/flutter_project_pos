import 'db_services.dart';
import '../models/user.dart';

class AuthServices {
  static Future<User?> login(String email, String password) async {
    final db = await DbService.instance.db;
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }
}
