class Pollutionmodel {
  final int aqi;
  final int dateTime;
  final double pm25;
  final double pm10;
  final double no2;
  final double so2;

  Pollutionmodel(
      {required this.aqi,
      required this.dateTime,
      required this.pm25,
      required this.pm10,
      required this.no2,
      required this.so2});

  factory Pollutionmodel.fromJson(Map<String, dynamic> json) {
    double _getDoubleValue(value) =>
        value != null ? double.parse(value.toString()) : 0.0;
    return Pollutionmodel(
      aqi: json['aqi'] ?? 0,
      dateTime: json['time']?['v'] ?? 0,
      pm25: _getDoubleValue(json['iaqi']?['pm25']?['v']),
      pm10: _getDoubleValue(json['iaqi']?['pm10']?['v']),
      no2: _getDoubleValue(json['iaqi']?['no2']?['v']),
      so2: _getDoubleValue(json['iaqi']?['so2']?['v']),
    );
  }
}
