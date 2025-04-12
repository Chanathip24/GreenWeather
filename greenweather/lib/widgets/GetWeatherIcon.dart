import 'package:flutter/material.dart';

class Getweathericon extends StatelessWidget {
  final String weatherMain;
  const Getweathericon({super.key, required this.weatherMain});

  @override
  Widget build(BuildContext context) {
    final Map<String, IconData> weatherIcons = {
      'clear': Icons.wb_sunny,
      'clouds': Icons.cloud,
      'rain': Icons.water_drop,
      'snow': Icons.ac_unit,
      'thunderstorm': Icons.bolt,
      'drizzle': Icons.grain,
      'mist': Icons.cloud,
      'fog': Icons.cloud,
      'haze': Icons.cloud,
    };

    final Map<String, Color> weatherColors = {
      'clear': Colors.amber[600]!,
      'clouds': Colors.blueGrey[400]!,
      'rain': Colors.blue[400]!,
      'snow': Colors.lightBlue[100]!,
      'thunderstorm': Colors.deepPurple[400]!,
      'drizzle': Colors.lightBlue[300]!,
      'mist': Colors.blueGrey[300]!,
      'fog': Colors.blueGrey[200]!,
      'haze': Colors.blueGrey[300]!,
    };

    final String weatherType = weatherMain.toLowerCase();
    final IconData iconData = weatherIcons[weatherType] ?? Icons.help_outline;
    final Color iconColor = weatherColors[weatherType] ?? Colors.grey;

    return Container(
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.all(12),
      child: Icon(
        iconData,
        color: iconColor,
        size: 48,
      ),
    );
  }
}
