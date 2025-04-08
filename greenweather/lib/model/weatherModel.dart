class WeatherModel {
  final String main;
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final String iconCode;
  final DateTime dateTime;
  final double feel_likes;
  final double visibility;

  WeatherModel(
      {required this.cityName,
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
        visibility: json['visibility'] / 1000,
        main: json['weather'][0]['main'],
        cityName: json['name'] ?? "Unknown",
        temperature: json['main']['temp'],
        feel_likes: json['main']['feels_like'],
        description: json['weather'][0]['description'],
        humidity: json['main']['humidity'],
        windSpeed: json['wind']['speed'],
        iconCode: json['weather'][0]['icon'] ?? "01d",
        dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000));
  }
}
