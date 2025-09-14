import 'package:flutter/foundation.dart';
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
}
