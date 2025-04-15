import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenweather/model/userModel.dart';

class UserlistService {
  final String? _apiUrl = dotenv.env['API_URL'] ?? "http://10.0.0.2:8082";
  final Dio _dio = Dio();

  Future<List<Usermodel>> getUserList() async {
    try {
      final response = await _dio.get("$_apiUrl/user/getusernoemail");
      if (response.statusCode == 200) {
        final List dataList = response.data['data'];
        return dataList.map((user) => Usermodel.fromJson(user)).toList();
      } else {
        throw Exception('Failed to load user list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error fetching user list: $e");
    }
  }
}
