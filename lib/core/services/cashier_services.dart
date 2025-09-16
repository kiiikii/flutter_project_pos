// ignore: unused_import
import 'package:sqflite/sqflite.dart';
import '../helpers/constant.dart';
import '../models/user.dart';
import '../services/db_services.dart';

/// Business Layer for Cashier CRUD + lightweight validation
class CashierServices {
  /* --------------------  READ  -------------------- */
  static Future<List<User>> index() async {
    final db = await DbService.instance.db;
    final maps = await db.query(
      'users',
      where: 'role = ?',
      whereArgs: [Constant.roleCashier],
      orderBy: 'name',
    );
    return maps.map((m) => User.fromMap(m)).toList();
  }

  /* --------------------  CREATE  -------------------- */
  static Future<void> create(User user) async {
    final db = await DbService.instance.db;

    /* -------------  bussiness rule : email must be unique  ------------- */
    final exist = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [user.email],
    );
    if (exist.isNotEmpty) throw Exception('Email Sudah terdaftar');

    await db.insert('users', user.toMap());
  }

  /* --------------------  UPDATE  -------------------- */
  static Future<void> update(User user) async {
    final db = await DbService.instance.db;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  /* --------------------  DELETE  -------------------- */
  static Future<void> delete(String id) async {
    final db = await DbService.instance.db;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
