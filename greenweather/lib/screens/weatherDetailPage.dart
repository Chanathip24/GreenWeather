import 'package:flutter/material.dart';
import 'package:greenweather/model/weatherModel.dart';
import 'package:greenweather/widgets/Dailyforecastlist.dart';
import 'package:greenweather/widgets/GetWeatherIcon.dart';
import 'package:greenweather/widgets/Hourlyforecastlist.dart';
import 'package:greenweather/widgets/Weatherinfocard.dart';
import 'package:intl/intl.dart';

class WeatherDetailPage extends StatelessWidget {
  final WeatherModel weather;
  final List<Weatherforecastmodel>? forecast; //7 day na
  final List<Weatherhourlymodel>? hourly; //24 hours na
  const WeatherDetailPage(
      {super.key, required this.weather, this.forecast, this.hourly});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('EEEE, MMM d, yyyy');
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
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              floating: true,
              pinned: true,
              expandedHeight: 0,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.cityName ?? 'Unknown Location',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormatter.format(weather.dateTime),
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
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      weather.temperature.toInt().toString(),
                                      style: TextStyle(
                                        fontSize: 72,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2E7D32),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: const Text(
                                        '°C',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2E7D32),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(weather.description,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2E7D32),
                                    ),
                                    softWrap: true),
                                Text(
                                  weather.main,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Feels like ${weather.feel_likes.toInt().toString()}°C',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color(0xFF2E7D32)
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Getweathericon(weatherMain: weather.main),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    WeatherInfoCard(
                      weather: weather,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Hourly Forecast',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 12),
                    HourlyForecastList(
                      hourlyWeather: hourly ?? [],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '7-Day Forecast',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DailyForecastList(
                      forecast: forecast!,
                    ),
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
