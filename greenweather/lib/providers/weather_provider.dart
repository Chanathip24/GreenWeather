import 'package:flutter/material.dart';
import 'package:greenweather/model/weatherModel.dart';
import 'package:greenweather/services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherModel? _currentWeather; // today weather 
  bool _isLoading = false;
  String? _error;
  List<Weatherforecastmodel>? _forecastWeather; //daily 7 days
  List<Weatherhourlymodel>? _hourlyWeather; //hourly 24 hours 3 hour gap
  
  //getters method
  List<Weatherhourlymodel>? get hourlyWeather => _hourlyWeather;
  List<Weatherforecastmodel>? get forecastWeather => _forecastWeather;
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
      final forecastData = await _weatherService.getForecastByCity(province); //day
      final hourlyData = await _weatherService.getHourlyForecastByCity(province); //hourly

      //hourly forecast
      _hourlyWeather = hourlyData;
      //5days forecast
      _forecastWeather = forecastData;
      //today forecast
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
