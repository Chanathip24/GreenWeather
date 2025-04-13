import 'package:flutter/material.dart';
import 'package:greenweather/model/weatherModel.dart';
import 'package:intl/intl.dart';

class HourlyForecastList extends StatelessWidget {
  final List<Weatherhourlymodel> hourlyWeather;
  const HourlyForecastList({super.key, required this.hourlyWeather});

  @override
  Widget build(BuildContext context) {
    final timeFormmater = DateFormat('HH:mm');
    if (hourlyWeather.isEmpty) {
      return const Center(
        child: Text(
          'No hourly forecast data available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: hourlyWeather.length,
        itemBuilder: (context, index) {
          final item = hourlyWeather[index];
          // Assume 13:00 is current hour

          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: null,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E7D32).withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeFormmater.format(item.dateTime),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
                Icon(
                  item.iconData,
                  size: 28,
                  color: item.iconData == Icons.wb_sunny
                      ? const Color(0xFFFFB74D) // Amber
                      : item.iconData == Icons.wb_cloudy
                          ? const Color(0xFF78909C) // Blue-grey
                          : item.iconData == Icons.grain
                              ? const Color(0xFF4FC3F7) // Light blue
                              : const Color(0xFF2196F3), // Bluego
                ),
                Text(
                  '${item.temperature.toInt()}°C',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
