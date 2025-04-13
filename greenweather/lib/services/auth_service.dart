import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenweather/model/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio dio = Dio();
  final String? _apiUrl = dotenv.env['API_URL'] ?? "http://10.0.0.2:8082";

  static String? validatePassword(
      String password, String confirmPassword, bool acceptTerms) {
    if (!acceptTerms) {
      return "กรุณายอมรับเงื่อนไขการใช้งาน";
    }
    if (password.isEmpty) {
      return "กรุณากรอกรหัสผ่าน";
    }
    if (confirmPassword.isEmpty) {
      return "กรุณากรอกยืนยันรหัสผ่าน";
    }
    if (password != confirmPassword) {
      return "รหัสผ่านไม่ตรงกัน";
    }
    if (password.length < 6) {
      return "รหัสผ่านต้องมีอย่างน้อยหกตัวอักษร";
    }

    final regExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$',
    );

    if (!regExp.hasMatch(password)) {
      return "รหัสผ่านต้องมีตัวอักษรพิมพ์ใหญ่ ตัวอักษรพิมพ์เล็ก ตัวเลข และอักขระพิเศษ อย่างละหนึ่งตัว";
    }

    return null;
  }

  //method
  Future<Usermodel> login(Usermodel user) async {
    try {
      final response = await dio.post("$_apiUrl/authentication/login",
          data: Usermodel.toJson(user));
      if (response.statusCode == 200) {
        //save token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'access_token', response.data['data']['token']['accessToken']);
        await prefs.setString(
            'refresh_token', response.data['data']['token']['refreshToken']);
        //return data
        return Usermodel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      // print(e); //debug
      throw Exception("Failed to login");
    }
  }

  Future<Usermodel> register(Usermodel user) async {
    try {
      final response = await dio.post("$_apiUrl/authentication/register",
          data: Usermodel.toJson(user));
      if (response.statusCode == 201) {
        //save token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'access_token', response.data['data']['token']['accessToken']);
        await prefs.setString(
            'refresh_token', response.data['data']['token']['refreshToken']);

        //return user data
        return Usermodel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to register: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // print(e.response?.data['message']); //debug
        throw Exception('Failed to register: ${e.response?.data['message']}');
      } else {
        // print(e.message); //debug
        throw Exception('Failed to register: ${e.message}');
      }
    } catch (e) {
      print(e); //debug
      throw Exception(e.toString());
    }
  }
}
