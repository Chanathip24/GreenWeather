import 'package:flutter/material.dart';
import 'package:greenweather/model/weatherModel.dart';
import 'package:greenweather/services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherModel? _currentWeather;
  bool _isLoading = false;
  String? _error;

  WeatherModel? get currentWeather => _currentWeather;
  bool get isLoading => _isLoading;
  String? get error => _error;
  final WeatherService _weatherService = WeatherService();

  Future<void> fetchWeatherData(String province) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final weatherData = await _weatherService.getWeatherByCity(province);
      _currentWeather = weatherData;
      _isLoading = false;

      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
}
