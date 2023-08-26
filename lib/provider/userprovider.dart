import 'package:flutter/widgets.dart';
import 'package:whatsapp_clone/auth/firebaselogic.dart';
import 'package:whatsapp_clone/models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    final user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
