import 'package:flutter/material.dart';
import 'package:greenweather/model/reviewModel.dart';
import 'package:greenweather/services/review_service.dart';

class ReviewProvider extends ChangeNotifier {
  List<Reviewmodel> _reviews = [];
  bool _isLoading = false;
  String? _error;

  //getters method
  List<Reviewmodel> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get error => _error;

  //api service
  final ReviewService _reviewService = ReviewService();

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
}
