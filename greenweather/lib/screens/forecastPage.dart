import 'package:flutter/material.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  State<ForecastPage> createState() =>
      _ForecastPageState(); // Fix: Use correct class name
}

class _ForecastPageState extends State<ForecastPage> {
  final List<Map<String, String>> weatherData = [
    {'date': '8 มีนาคม', 'temp': '32°C', 'condition': 'มีแดดจัด'},
    {'date': '9 มีนาคม', 'temp': '30°C', 'condition': 'มีเมฆบางส่วน'},
    {'date': '10 มีนาคม', 'temp': '31°C', 'condition': 'มีแดดจัด'},
    {'date': '11 มีนาคม', 'temp': '29°C', 'condition': 'ฝนตก'},
    {'date': '12 มีนาคม', 'temp': '28°C', 'condition': 'มีเมฆมาก'},
    {'date': '13 มีนาคม', 'temp': '30°C', 'condition': 'มีแดดจัด'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather forecast"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: weatherData.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> data = entry.value;
                return WeatherCard(
                  date: data['date']!,
                  temp: data['temp']!,
                  condition: data['condition']!,
                  isFirst: index == 0,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  final String date;
  final String temp;
  final String condition;
  final bool isFirst;

  WeatherCard(
      {required this.date,
      required this.temp,
      required this.condition,
      required this.isFirst});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isFirst
              ? Colors.green.shade100
              : const Color.fromARGB(255, 221, 241, 201),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'วันนี้',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  date,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            CircleAvatar(
              backgroundColor: Colors.yellow,
              radius: 24,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  temp,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Text(
                  condition,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
