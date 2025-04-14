import 'package:flutter/material.dart';
import 'package:greenweather/model/transactionModel.dart';
import 'package:greenweather/model/userModel.dart';
import 'package:greenweather/services/api_service.dart';
import 'package:greenweather/services/auth_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  Usermodel? _userdata;
  List<Transactionmodel> _transactions = [];

  bool _loading = false;
  bool _isAuthenticate = false;
  String? _error;

  //getter
  List<Transactionmodel> get transactions => _transactions;
  Usermodel? get userdata => _userdata;
  bool get isAuthenticate => _isAuthenticate;
  String? get error => _error;
  bool get isLoading => _loading;

  AuthenticationProvider() {
    _checkloginStatus();
    getTransaction();
  }

  //api service
  final _apiService = Apiservice();
  final _authService = AuthService();

  //get transaction
  Future<void> getTransaction() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _transactions = await _apiService.getTransactionHistory();
      _loading = false;
      notifyListeners();
    } catch (e) {
      _transactions = [];
      _loading = false;
      notifyListeners();
    }
  }

  //check login status
  Future<void> _checkloginStatus() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _isAuthenticate = await _apiService.isLoggedIn();

      if (_isAuthenticate) {
        _userdata = await _apiService.getUserInfo();
      }

      _loading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isAuthenticate = false;
      _loading = false;
      notifyListeners();
    }
  }

  //login method
  Future<void> login(Usermodel user) async {
    // final prefs = await SharedPreferences.getInstance();

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _userdata = await _authService.login(user);

      _isAuthenticate = true;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isAuthenticate = false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  //register method
  Future<void> register(Usermodel user) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _userdata = await _authService.register(user);

      _isAuthenticate = true;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isAuthenticate = false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      //logout from api
      bool result = await _apiService.logout();
      if (result) {
        //remove user data
        _userdata = null;
        _isAuthenticate = false;
      } else {
        _error = "Logout failed";
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
