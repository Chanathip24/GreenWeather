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

  static IconData getWeatherIcon(String main) {
    switch (main.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny_outlined; // แดดจัด
      case 'clouds':
        return Icons.cloud_outlined; // มีเมฆ
      case 'rain':
      case 'drizzle':
        return Icons.grain; // ฝนตก / ฝนปรอยๆ
      case 'thunderstorm':
        return Icons.flash_on; // พายุฟ้าคะนอง
      case 'snow':
        return Icons.ac_unit; // หิมะ
      case 'mist':
      case 'fog':
      case 'haze':
        return Icons.blur_on; // หมอก
      default:
        return Icons.help_outline; // สภาพอากาศไม่แน่นอน
    }
  }

  static String getWeatherText(String main) {
    switch (main.toLowerCase()) {
      case 'clear':
        return 'แดดจัด';
      case 'clouds':
        return 'มีเมฆมาก';
      case 'rain':
        return 'ฝนตก';
      case 'thunderstorm':
        return 'พายุฝนฟ้าคะนอง';
      case 'drizzle':
        return 'ฝนปรอยๆ';
      case 'snow':
        return 'หิมะตก';
      case 'mist':
      case 'fog':
      case 'haze':
        return 'หมอกลง';
      default:
        return 'สภาพอากาศไม่แน่นอน';
    }
  }
}
