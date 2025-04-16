import 'package:flutter/material.dart';

class MockServices {
  static String getMonth(int month) {
    const List<String> months = [
      'ม.ค.',
      'ก.พ.',
      'มี.ค.',
      'เม.ย.',
      'พ.ค.',
      'มิ.ย.',
      'ก.ค.',
      'ส.ค.',
      'ก.ย.',
      'ต.ค.',
      'พ.ย.',
      'ธ.ค.'
    ];
    return months[month - 1];
  }

  static Color getAqiColor(int aqi) {
    final List<Color> colors = [
      Colors.green.shade400,
      Colors.orange,
      Colors.amber.shade700,
      Colors.red.shade400,
      Colors.purple.shade400,
    ];
    if (aqi <= 50) {
      return colors[0];
    } else if (aqi <= 100) {
      return colors[1];
    } else if (aqi <= 150) {
      return colors[2];
    } else if (aqi <= 200) {
      return colors[3];
    } else {
      return colors[4];
    }
  }

  static IconData getWeatherIcon(int index) {
    final List<IconData> icons = [
      Icons.wb_sunny_outlined,
      Icons.cloud_outlined,
      Icons.grain,
      Icons.thermostat,
    ];
    return icons[index % icons.length];
  }

  static String getWeatherText(int index) {
    final List<String> weather = [
      'แดดจัด',
      'มีเมฆมาก',
      'ฝนตก',
      'ร้อนมาก',
    ];
    return weather[index % weather.length];
  }
}
