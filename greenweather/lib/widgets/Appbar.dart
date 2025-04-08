import 'package:flutter/material.dart';
import 'package:greenweather/providers/province_provider.dart';
import 'package:greenweather/providers/weather_provider.dart';
import 'package:provider/provider.dart';

class MainAppBar extends StatelessWidget {
  final WeatherProvider? weatherProvider;

  const MainAppBar({super.key, this.weatherProvider});

  @override
  Widget build(BuildContext context) {
    // Get the provider without using Consumer
    final provinceProvider = Provider.of<ProvinceProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.green[400], size: 20),
              const SizedBox(width: 4),
              DropdownButton<String>(
                value: provinceProvider.selectProvince,
                items: provinceProvider.provinces.keys
                    .map<DropdownMenuItem<String>>((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(
                        provinceProvider.provinces[key]?["th"] ?? "ม่ายลุ"),
                  );
                }).toList(),
                onChanged: (String? value) async {
                  if (value != null) {
                    provinceProvider.setProvince(value);

                    if (weatherProvider != null) {
                      await weatherProvider!.fetchWeatherData(value);
                    }
                  }
                },
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
