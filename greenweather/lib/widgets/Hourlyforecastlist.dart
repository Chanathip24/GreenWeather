import 'package:flutter/material.dart';

class HourlyForecastList extends StatelessWidget {
  const HourlyForecastList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> hourlyData = [
      {'time': '10:00', 'temp': 28, 'icon': Icons.wb_sunny},
      {'time': '11:00', 'temp': 29, 'icon': Icons.wb_sunny},
      {'time': '12:00', 'temp': 31, 'icon': Icons.wb_sunny},
      {'time': '13:00', 'temp': 32, 'icon': Icons.wb_sunny},
      {'time': '14:00', 'temp': 32, 'icon': Icons.wb_sunny},
      {'time': '15:00', 'temp': 32, 'icon': Icons.wb_cloudy},
      {'time': '16:00', 'temp': 31, 'icon': Icons.wb_cloudy},
      {'time': '17:00', 'temp': 30, 'icon': Icons.wb_cloudy},
      {'time': '18:00', 'temp': 29, 'icon': Icons.nights_stay},
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: hourlyData.length,
        itemBuilder: (context, index) {
          final item = hourlyData[index];
          final bool isCurrentHour = index == 3; // Assume 13:00 is current hour

          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: isCurrentHour
                  ? const Color(0xFF4CAF50).withOpacity(0.15)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: isCurrentHour
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['time'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isCurrentHour ? FontWeight.bold : FontWeight.w500,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
                Icon(
                  item['icon'],
                  size: 28,
                  color: item['icon'] == Icons.wb_sunny
                      ? const Color(0xFFFFB74D) // Amber
                      : item['icon'] == Icons.wb_cloudy
                          ? const Color(0xFF78909C) // Blue-grey
                          : const Color(0xFF5C6BC0), // Indigo
                ),
                Text(
                  '${item['temp']}°C',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        isCurrentHour ? FontWeight.bold : FontWeight.w500,
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
