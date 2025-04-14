import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenweather/model/userModel.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Apiservice {
  final Dio _dio = Dio();
  final String baseUrl = dotenv.env['API_URL'] ?? "http://10.0.2.2:8082";

  // Retry request with new token
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
        '$baseUrl/authentication/refresh', // Replace with your refresh token endpoint
        data: {
          'refreshToken': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        // Save new tokens
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

  Apiservice() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add any request interceptors here if needed
        final prefs = await SharedPreferences.getInstance();
        final accessToken = prefs.getString('access_token');

        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options); // continue with the request
      },
      onError: (DioException error, handler) async {
        // Handle errors here
        if (error.response?.statusCode == 401) {
          try {
            await refreshToken(); // Refresh token if 401 error occurs
            return handler.resolve(await _retry(error.requestOptions));
          } catch (e) {
            //wait for logout
            return handler.next(error);
          }
        }
        return handler.next(error); // continue with the error
      },
    ));
  }
}
