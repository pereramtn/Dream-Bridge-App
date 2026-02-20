import 'package:dream_bridge_app/models/user_models.dart';
import 'package:flutter/material.dart';


class UserProvider extends ChangeNotifier {
  UserModel? user;

  void setUser(UserModel newUser) {
    user = newUser;
    notifyListeners();
  }

  void clearUser() {
    user = null;
    notifyListeners();
  }

  bool get isLoggedIn => user != null;
}
