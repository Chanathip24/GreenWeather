import 'package:flutter/material.dart';
import 'package:greenweather/model/weatherModel.dart';
import 'package:intl/intl.dart';

class DailyForecastList extends StatelessWidget {
  
  final List<Weatherforecastmodel> forecast; //5 day na
  const DailyForecastList({super.key,required this.forecast});


  @override
  
  Widget build(BuildContext context) {
    final dayFormatter = DateFormat('EE');
    final dateFormatter = DateFormat('MMM, d');
    if (forecast.isEmpty) {
      return const Center(
        child: Text(
          'No forecast data available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: forecast.length,
      itemBuilder: (context, index) {
        final item = forecast[index];
        final bool isToday = index == 0;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: isToday
                ? const Color(0xFF4CAF50).withOpacity(0.15)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: isToday
                ? Border.all(color: const Color(0xFF4CAF50), width: 1.5)
                : null,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E7D32).withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayFormatter.format(item.dateTime),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormatter.format(item.dateTime),
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF2E7D32).withOpacity(0.7),
                      ),
                    ),
                  ],
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
                            : const Color(0xFF2196F3), // Blue
              ),
              Row(
                children: [
                  Text(
                    '${item.temp_min.toInt()}°',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color(0xFF2E7D32).withOpacity(0.7),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF81C784),
                          const Color(0xFFFFB74D)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Text(
                    '${item.temp_max.toInt()}°',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
