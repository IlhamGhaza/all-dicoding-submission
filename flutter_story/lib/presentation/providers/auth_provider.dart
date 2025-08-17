import 'package:flutter/material.dart';

import '../../core/state/api_state.dart';
import '../../data/models/user_model.dart';
import '../../data/services/api_service.dart';
import '../../data/services/storage_service.dart';


class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  ApiState<User> _loginState = const ApiInitial();
  ApiState<bool> _registerState = const ApiInitial();
  User? _currentUser;
  bool _isLoggedIn = false;

  ApiState<User> get loginState => _loginState;
  ApiState<bool> get registerState => _registerState;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkAuthStatus() async {
    final user = await StorageService.getUser();
    if (user != null && user.token.isNotEmpty) {
      _currentUser = user;
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _loginState = const ApiLoading();
    notifyListeners();

    try {
      final user = await _apiService.login(email, password);
      await StorageService.saveUser(user);

      _currentUser = user;
      _isLoggedIn = true;
      _loginState = ApiSuccess(user);
      notifyListeners();
    } catch (e) {
      _loginState = ApiError(e.toString());
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    _registerState = const ApiLoading();
    notifyListeners();

    try {
      final success = await _apiService.register(name, email, password);
      _registerState = ApiSuccess(success);
      notifyListeners();
    } catch (e) {
      _registerState = ApiError(e.toString());
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await StorageService.clearUser();
    _currentUser = null;
    _isLoggedIn = false;
    _loginState = const ApiInitial();
    _registerState = const ApiInitial();
    notifyListeners();
  }

  void resetStates() {
    _loginState = const ApiInitial();
    _registerState = const ApiInitial();
    notifyListeners();
  }
}
