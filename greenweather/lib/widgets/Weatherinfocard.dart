import 'package:flutter/material.dart';
import 'package:greenweather/model/weatherModel.dart';
import 'package:greenweather/widgets/Weatherinfocarditem.dart';

class WeatherInfoCard extends StatelessWidget {
  final WeatherModel weather;
  const WeatherInfoCard({super.key, required this.weather});

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
        children: [
          WeatherInfoItem(
            icon: Icons.water_drop_outlined,
            label: 'Humidity',
            value: '${weather.humidity.toInt().toString()}%',
          ),
          WeatherInfoItem(
            icon: Icons.air,
            label: 'Wind',
            value: '${weather.windSpeed} km/h',
          ),
          WeatherInfoItem(
            icon: Icons.remove_red_eye_outlined,
            label: 'Visibility',
            value: '${weather.visibility} km',
          ),
        ],
      ),
    );
  }
}
