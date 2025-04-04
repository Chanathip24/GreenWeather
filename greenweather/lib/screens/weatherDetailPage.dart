import 'package:flutter/material.dart';

class WeatherDetailPage extends StatelessWidget {
  const WeatherDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F0), // Light green background
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              leading: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32)), // Dark green
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              floating: true,
              pinned: false,
              expandedHeight: 0,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bangkok',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32), // Dark green
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Monday, 10 March 2025',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF2E7D32).withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2E7D32).withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '32',
                                    style: TextStyle(
                                      fontSize: 72,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2E7D32), // Dark green
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: const Text(
                                      '°C',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2E7D32), // Dark green
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                'Sunny',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2E7D32), // Dark green
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Feels like 34°C',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color(0xFF2E7D32).withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10, right: 10),
                            child: Icon(
                              Icons.wb_sunny,
                              size: 72,
                              color: Color(0xFFFFB74D), // Amber, slightly more muted
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const WeatherInfoCard(),
                    const SizedBox(height: 24),
                    const Text(
                      'Hourly Forecast',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32), // Dark green
                      ),
                    ),
                    const SizedBox(height: 12),
                    const HourlyForecastList(),
                    const SizedBox(height: 24),
                    const Text(
                      '7-Day Forecast',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32), // Dark green
                      ),
                    ),
                    const SizedBox(height: 12),
                    const DailyForecastList(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherInfoCard extends StatelessWidget {
  const WeatherInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          WeatherInfoItem(
            icon: Icons.water_drop_outlined,
            label: 'Humidity',
            value: '65%',
          ),
          WeatherInfoItem(
            icon: Icons.air,
            label: 'Wind',
            value: '10 km/h',
          ),
          WeatherInfoItem(
            icon: Icons.remove_red_eye_outlined,
            label: 'Visibility',
            value: '16 km',
          ),
        ],
      ),
    );
  }
}

class WeatherInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherInfoItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 28,
          color: const Color(0xFF4CAF50), // Medium green
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: const Color(0xFF2E7D32).withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32), // Dark green
          ),
        ),
      ],
    );
  }
}

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
              color: isCurrentHour ? const Color(0xFF4CAF50).withOpacity(0.15) : Colors.white,
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
                    fontWeight: isCurrentHour ? FontWeight.bold : FontWeight.w500,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
                Icon(
                  item['icon'],
                  size: 28,
                  color: item['icon'] == Icons.wb_sunny
                      ? const Color(0xFFFFB74D)  // Amber
                      : item['icon'] == Icons.wb_cloudy
                          ? const Color(0xFF78909C)  // Blue-grey
                          : const Color(0xFF5C6BC0),  // Indigo
                ),
                Text(
                  '${item['temp']}°C',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isCurrentHour ? FontWeight.bold : FontWeight.w500,
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
            color: isToday ? const Color(0xFF4CAF50).withOpacity(0.15) : Colors.white,
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
                    ? const Color(0xFFFFB74D)  // Amber
                    : item['icon'] == Icons.wb_cloudy
                        ? const Color(0xFF78909C)  // Blue-grey
                        : item['icon'] == Icons.grain
                            ? const Color(0xFF4FC3F7)  // Light blue
                            : const Color(0xFF2196F3),  // Blue
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
                        colors: [const Color(0xFF81C784), const Color(0xFFFFB74D)],
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