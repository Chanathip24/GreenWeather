import 'package:flutter/material.dart';
import 'package:greenweather/model/userModel.dart';
import 'package:greenweather/services/userlist_service.dart';

class UserlistProvider extends ChangeNotifier {
  List<Usermodel> _usersList = [];
  bool _isLoading = false;
  String? _error;

  //getters
  List<Usermodel> get usersList => _usersList;
  bool get isEmpty => _usersList.isEmpty;
  bool get isLoading => _isLoading;
  String? get error => _error;

  //api service
  final UserlistService _userlistService = UserlistService();

  //method

  //fetch all user
  Future<void> getAllUser() async {
    _isLoading = true;
    _error = null;
    _usersList = [];
    notifyListeners();

    try {
      final users = await _userlistService.getUserList();
      _usersList = users;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
