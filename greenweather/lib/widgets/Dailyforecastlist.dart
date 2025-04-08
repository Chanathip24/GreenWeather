import 'package:flutter/material.dart';

class DailyForecastList extends StatelessWidget {
  const DailyForecastList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dailyData = [
      {
        'day': 'Today',
        'date': '10 Mar',
        'minTemp': 25,
        'maxTemp': 32,
        'icon': Icons.wb_sunny
      },
      {
        'day': 'Tue',
        'date': '11 Mar',
        'minTemp': 24,
        'maxTemp': 31,
        'icon': Icons.wb_sunny
      },
      {
        'day': 'Wed',
        'date': '12 Mar',
        'minTemp': 25,
        'maxTemp': 32,
        'icon': Icons.wb_sunny
      },
      {
        'day': 'Thu',
        'date': '13 Mar',
        'minTemp': 24,
        'maxTemp': 30,
        'icon': Icons.wb_cloudy
      },
      {
        'day': 'Fri',
        'date': '14 Mar',
        'minTemp': 23,
        'maxTemp': 29,
        'icon': Icons.grain
      },
      {
        'day': 'Sat',
        'date': '15 Mar',
        'minTemp': 22,
        'maxTemp': 28,
        'icon': Icons.water
      },
      {
        'day': 'Sun',
        'date': '16 Mar',
        'minTemp': 24,
        'maxTemp': 30,
        'icon': Icons.wb_cloudy
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dailyData.length,
      itemBuilder: (context, index) {
        final item = dailyData[index];
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
                      item['day'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['date'],
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF2E7D32).withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                item['icon'],
                size: 28,
                color: item['icon'] == Icons.wb_sunny
                    ? const Color(0xFFFFB74D) // Amber
                    : item['icon'] == Icons.wb_cloudy
                        ? const Color(0xFF78909C) // Blue-grey
                        : item['icon'] == Icons.grain
                            ? const Color(0xFF4FC3F7) // Light blue
                            : const Color(0xFF2196F3), // Blue
              ),
              Row(
                children: [
                  Text(
                    '${item['minTemp']}°',
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
                    '${item['maxTemp']}°',
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
