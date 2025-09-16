import 'package:flutter/foundation.dart';
import 'package:resto_pos/core/services/db_services.dart';
import '../models/user.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthProviders with ChangeNotifier {
  User? _user;

  User? get user => _user;

  /* ----- Private Helper ----- */
  String _hash(String plain) => sha256.convert(utf8.encode(plain)).toString();

  /* ----- Login ----- */
  Future<bool> login(String email, String password) async {
    final db = await DbService.instance.db;
    final hashed = _hash(password);
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashed],
    );

    if (maps.isEmpty) return false;
    _user = User.fromMap(maps.first);
    notifyListeners();
    return true;
  }

  /* ----- Logout ----- */
  void logout() {
    _user = null;
    notifyListeners();
  }

  /* ----- Updating ----- */
  Future<void> updateProfile({
    required String name,
    required String email,
    required String newPassword,
  }) async {
    final db = await DbService.instance.db;

    /* ----- 1. email uniqueness check ----- */
    if (email != _user!.email) {
      final exist = await db.query(
        'users',
        where: 'email = ? AND id != ?',
        whereArgs: [email, _user!.id],
      );
      if (exist.isNotEmpty) throw Exception('Email sudah dipakai user lain');
    }

    /* ----- 2. build updates ----- */
    final update = <String, dynamic>{'name': name, 'email': email};
    if (newPassword.isNotEmpty) update['password'] = _hash(newPassword);

    await db.update(
      'users',
      update,
      where: 'id = ?',
      whereArgs: [_user!.id],
    );

    // refresh local user object
    _user = User(
      id: _user!.id,
      name: name,
      email: _user!.email,
      password: newPassword.isEmpty ? _user!.password : newPassword,
      role: _user!.role,
    );
    notifyListeners();
  }
}
