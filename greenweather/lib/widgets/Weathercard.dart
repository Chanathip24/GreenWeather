import 'package:flutter/material.dart';
import 'package:greenweather/model/weatherModel.dart';
import 'package:greenweather/widgets/GetWeatherIcon.dart';
import 'package:greenweather/widgets/WeatherInfoItem.dart';
import 'package:intl/intl.dart';

class buildWeatherCard extends StatelessWidget {
  final WeatherModel weather;
  const buildWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('EEEE, MMM d, yyyy');
    final timeFormatter = DateFormat('h:mm a');
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateFormatter.format(weather.dateTime),
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weather.temperature.toInt().toString(),
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '°C',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      weather.description,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Getweathericon(weatherMain: weather.main),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Weatherinfoitem(
                icon: Icons.water_drop,
                label: 'ความชื้น',
                value: "${weather.humidity}%",
                color: Colors.blue,
              ),
              Weatherinfoitem(
                icon: Icons.air,
                label: 'ลม',
                value: '${weather.windSpeed} กม./ชม.',
                color: Colors.blue[300]!,
              ),
              Weatherinfoitem(
                icon: Icons.thermostat,
                label: 'ความรู้สึก',
                value: '${weather.feel_likes.toInt().toString()}°C',
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
    ;
  }
}
