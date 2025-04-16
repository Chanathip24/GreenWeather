import 'package:flutter/material.dart';
import 'package:greenweather/model/reviewLikeModel.dart';
import 'package:greenweather/model/reviewModel.dart';
import 'package:greenweather/services/api_service.dart';
import 'package:greenweather/services/review_service.dart';

class ReviewProvider extends ChangeNotifier {
  List<Reviewmodel> _reviews = [];

  List<Reviewlikemodel> _userLike = [];

  bool _isLoading = false;
  String? _error;

  //getters method
  List<Reviewmodel> get reviews => _reviews;
  List<Reviewlikemodel> get userLikedata => _userLike;
  bool get isLoading => _isLoading;
  String? get error => _error;

  //api service
  final ReviewService _reviewService = ReviewService();
  final Apiservice _apiservice =
      Apiservice(); // ใช้ตัวนี้ส่ง access token ไปด้วย

  //ดึงข้อมูล like ของ user
  Future<void> userLike() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      List<Reviewlikemodel> likeData = await _apiservice.getUserLike();
      _userLike = likeData;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _userLike = [];
      notifyListeners();
    }
  }

  //user กดไลค์จะเซฟไว้ใน db
  Future<void> saveLike(Reviewlikemodel review) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiservice.saveUserLike(review);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  //user กดไลค์จะลบใน db
  Future<void> deleteLike(Reviewlikemodel review) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiservice.deleteUserLike(review);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  //get all reviews
  Future<void> getAllReviews(String cityname) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _reviews = await _reviewService.getAllReviews(cityname);
      _isLoading = false;

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _reviews = [];
      notifyListeners();
    }
  }

  //create review
  Future<void> addReview(Reviewmodel review) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _reviewService.addReview(review);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  //update post's like
  Future<void> postLike(Reviewlikemodel like) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _reviewService.updateLikereview(like);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
}
