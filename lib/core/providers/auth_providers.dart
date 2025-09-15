import 'package:flutter/foundation.dart';
import 'package:resto_pos/core/services/db_services.dart';
import '../models/user.dart';
import '../services/auth_services.dart';

class AuthProviders with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<bool> login(String email, String password) async {
    _user = await AuthServices.login(email, password);
    notifyListeners();
    return _user != null;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  Future<void> updateProfile(
      {required String name, required String newPassword}) async {
    final db = await DbService.instance.db;
    final update = <String, dynamic>{'name': name};
    if (newPassword.isNotEmpty) update['password'] = newPassword;

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
