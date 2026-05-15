import 'package:dream_bridge_app/models/user_models.dart';
import 'package:flutter/material.dart';


class UserProvider extends ChangeNotifier {
  StudentModel? student;

  void setUser(StudentModel newUser) {
    student = newUser;
    notifyListeners();
  }

  void clearUser() {
    student = null;
    notifyListeners();
  }

  bool get isLoggedIn => student != null;
}
