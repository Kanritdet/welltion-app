import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/mock_data.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  AuthProvider() {
    _currentUser = MockData.currentUser;
  }

  Future<void> login({required String email, required String password}) async {
    _currentUser = await ApiService().login(email: email, password: password);
    notifyListeners();
  }

  Future<void> logout() async {
    await ApiService().logout();
    _currentUser = null;
    notifyListeners();
  }
}
