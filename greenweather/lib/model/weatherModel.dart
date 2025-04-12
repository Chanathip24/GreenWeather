import 'package:flutter/material.dart';

IconData getIcon(String main) {
  switch (main.toLowerCase()) {
    case 'clear':
      return Icons.wb_sunny;
    case 'clouds':
      return Icons.wb_cloudy;
    case 'rain':
      return Icons.grain;
    case 'snow':
      return Icons.ac_unit;
    case 'thunderstorm':
      return Icons.flash_on;
    case 'drizzle':
      return Icons.grain;
    case 'mist':
      return Icons.cloud;
    case 'fog':
      return Icons.cloud;
    default:
      return Icons.error;
  }
}

class WeatherModel {
  final String main;
  final String? cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final String iconCode;
  final DateTime dateTime;
  final double feel_likes;
  final double visibility;

  WeatherModel(
      { this.cityName,
      required this.visibility,
      required this.temperature,
      required this.description,
      required this.humidity,
      required this.windSpeed,
      required this.iconCode,
      required this.dateTime,
      required this.feel_likes,
      required this.main});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
        visibility: double.parse((json['visibility'] / 1000).toString()), 
        main: json['weather'][0]['main'], 
        cityName: json['name'] ?? "Unknown location", 
        temperature: double.parse(json['main']['temp'].toString()), 
        feel_likes: double.parse(json['main']['feels_like'].toString()),
        description: json['weather'][0]['description'],
        humidity: json['main']['humidity'],
        windSpeed: double.parse(json['wind']['speed'].toString()),
        iconCode: json['weather'][0]['icon'] ?? "01d",
        dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000));
  }
}

class Weatherforecastmodel {
  final String main;
  final double temp_min;
  final double temp_max;
  final String description;
  final int humidity;
  final DateTime dateTime;
  final IconData iconData;

  Weatherforecastmodel(
      {required this.temp_min,
      required this.temp_max,
      required this.description,
      required this.humidity,
      required this.dateTime,
      required this.main,
      required this.iconData});

  factory Weatherforecastmodel.fromJson(Map<String, dynamic> json) {
    return Weatherforecastmodel(
        main: json['weather'][0]['main'], 
        temp_min: double.parse(json['temp']['min'].toString()), 
        temp_max: double.parse(json['temp']['max'].toString()), 
        description: json['weather'][0]['description'], 
        humidity: json['humidity'],
        iconData: getIcon(json['weather'][0]['main']), 
        dateTime:
            DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000)); 
  }
}

class Weatherhourlymodel{
  final String main;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final DateTime dateTime;
  final double temp_min;
  final double temp_max;
  final IconData iconData;
  final double feel_likes;

  Weatherhourlymodel(
      {required this.temperature,
      required this.description,
      required this.humidity,
      required this.windSpeed,
      required this.dateTime,
      required this.main,
      required this.temp_min,
      required this.temp_max,
      required this.iconData,
      required this.feel_likes});

  factory Weatherhourlymodel.fromJson(Map<String, dynamic> json) {
    return Weatherhourlymodel(
        main: json['weather'][0]['main'], 
        temperature: double.parse(json['main']['temp'].toString()), 
        feel_likes: double.parse(json['main']['feels_like'].toString()),
        temp_min: double.parse(json['main']['temp_min'].toString()),
        temp_max: double.parse(json['main']['temp_max'].toString()),
        iconData: getIcon(json['weather'][0]['main']), // wait for function
        description: json['weather'][0]['description'], 
        humidity: json['main']['humidity'],
        windSpeed: double.parse(json['wind']['speed'].toString()), 
        dateTime:
            DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000)); 
  }
}