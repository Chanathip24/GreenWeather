import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenweather/model/reviewLikeModel.dart';
import 'package:greenweather/model/reviewModel.dart';

class ReviewService {
  final Dio _dio = Dio();
  final String? _apiUrl = dotenv.env['API_URL'] ?? "http://10.0.0.2:8082";

  Future<List<Reviewmodel>> getAllReviews(String cityname) async {
    try {
      final response = await _dio.get("$_apiUrl/review/getallreviewslocate",
          queryParameters: {'location': cityname});
      if (response.statusCode == 200) {
        final List dataList = response.data['data'];
        return dataList.map((item) => Reviewmodel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load reviews: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error fetching reviews: $e");
    }
  }

  //add review
  Future<void> addReview(Reviewmodel review) async {
    try {
      final response = await _dio.post("$_apiUrl/review/createreview",
          data: review.toJson());
      if (response.statusCode != 201) {
        throw Exception('Failed to add review: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error adding review: $e");
    }
  }

  //update review like
  Future<void> updateLikereview(Reviewlikemodel like) async {
    try {
      final response =
          await _dio.put('$_apiUrl/review/addlikereview', data: like.toJson());
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to like/unlike the post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error like/unlike the post: $e");
    }
  }
}
