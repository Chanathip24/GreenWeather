import 'package:dio/dio.dart'; //lib
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenweather/model/weatherModel.dart';

class WeatherService {
  final Dio _dio = Dio();
  final String? _apiUrl = dotenv.env['API_URL'] ?? "http://10.0.0.2:8082";

  Future<WeatherModel> getWeatherByCity(String cityname) async {
    try {
      final response = await _dio
          .get("$_apiUrl/weather/", queryParameters: {'location': cityname});
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error fetching weather data: $e");
    }
  }
}
