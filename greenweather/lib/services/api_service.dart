import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenweather/model/Redemptionmodel.dart';
import 'package:greenweather/model/reviewLikeModel.dart';
import 'package:greenweather/model/transactionModel.dart';
import 'package:greenweather/model/userModel.dart';

import 'package:shared_preferences/shared_preferences.dart';

//service นี้แถม access token ไปกับ request ด้วย
class Apiservice {
  final Dio _dio = Dio();
  final String baseUrl = dotenv.env['API_URL'] ?? "http://10.0.2.2:8082";

  // Retry request
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  // Refresh token method
  Future<void> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');

    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    try {
      final response = await Dio().post(
        '$baseUrl/authentication/refresh',
        data: {
          'refreshToken': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        await prefs.setString(
            'refresh_token', response.data['data']['refreshToken']);
        await prefs.setString(
            'access_token', response.data['data']['accessToken']);
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      throw Exception('Failed to refresh token: $e');
    }
  }

  //check token if login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("access_token");
  }

  //logout
  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    bool? result = null;
    try {
      await _dio.get('$baseUrl/authentication/logout');
      result = true;
    } catch (e) {
      result = false;
      throw Exception('Failed to logout: $e');
    } finally {
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      return result!;
    }
  }

  Future<Usermodel> getUserInfo() async {
    try {
      final response = await _dio.get('$baseUrl/authentication/getuser');
      return Usermodel.fromJson(response.data['data']['user']);
    } catch (e) {
      throw Exception('Failed to get user info: $e');
    }
  }

  Future<List<Transactionmodel>> getTransactionHistory() async {
    try {
      final response = await _dio.get('$baseUrl/transaction/gettransaction');

      List<Transactionmodel> transactions = (response.data['data'] as List)
          .map((e) => Transactionmodel.fromJson(e))
          .toList();
      return transactions;
    } catch (e) {
      throw Exception('Failed to get transaction history: $e');
    }
  }

  //แก้ไข User ส่ง acesstoken ไปด้วย
  Future<Usermodel> updateUser(Usermodel user) async {
    try {
      final response =
          await _dio.put('$baseUrl/user/update', data: user.toJson());

      await refreshToken();
      return Usermodel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception("Failed to update user");
    }
  }

  //get user's like with access token
  Future<List<Reviewlikemodel>> getUserLike() async {
    try {
      final response = await _dio.get('$baseUrl/review/like/all');
      final List dataList = response.data['data'];

      return dataList.map((item) => Reviewlikemodel.fromJson(item)).toList();
    } catch (e) {
      throw Exception("Failed to get user's like");
    }
  }

  //delete like
  Future<Reviewlikemodel> deleteUserLike(Reviewlikemodel review) async {
    try {
      final response = await _dio.delete('$baseUrl/review/like/deletelike',
          data: review.toJson());

      return Reviewlikemodel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception("Failed to like the post.");
    }
  }

  //save like of user to db
  Future<Reviewlikemodel> saveUserLike(Reviewlikemodel review) async {
    try {
      final response = await _dio.post('$baseUrl/review/like/savelike',
          data: review.toJson());

      return Reviewlikemodel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception("Failed to like the post.");
    }
  }

  //redeem
  Future<Redemption> redeemReward(Redemption redeem) async {
    try {
      final response =
          await _dio.post('$baseUrl/reward/user/redeem', data: redeem.toJson());
      if (response.statusCode != 200) {
        throw Exception("Failed to redeem with status ${response.statusCode}");
      }
      return Redemption.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception("Failed to redeem ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error $e");
    }
  }

  //get all redeem by user
  Future<List<Redemption>> getAllredeem() async {
    try {
      final response = await _dio.get("$baseUrl/reward/user/redemptions");
      if (response.statusCode != 200) {
        throw Exception(
            "Failed to get data with status code ${response.statusCode}");
      }
      final List data = response.data['data'];
      print("trying to do object");

      // Create and init all Redemption objects asynchronously
      final List<Redemption> redemptions = await Future.wait(
        data.map((item) async {
          final redemption = Redemption.fromJson(item);
          await redemption.init();
          return redemption;
        }),
      );

      return redemptions;
    } on DioException catch (e) {
      throw Exception("Failed to redeem ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error $e");
    }
  }

  Apiservice() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final accessToken = prefs.getString('access_token');

        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        // Handle errors
        if (error.response?.statusCode == 401) {
          try {
            await refreshToken();
            return handler.resolve(await _retry(error.requestOptions));
          } catch (e) {
            //wait for logout
            return handler.next(error);
          }
        }
        return handler.next(error);
      },
    ));
  }
}
