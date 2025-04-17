import 'package:flutter/material.dart';
import 'package:greenweather/model/adviceModel.dart';
import 'package:greenweather/providers/authentication_provider.dart';
import 'package:greenweather/providers/pollution_provider.dart';
import 'package:greenweather/providers/province_provider.dart';
import 'package:greenweather/providers/weather_provider.dart';
import 'package:greenweather/screens/weatherDetailPage.dart';
import 'package:greenweather/widgets/Airqualitycard.dart';
import 'package:greenweather/widgets/Appbar.dart';
import 'package:greenweather/widgets/Weathercard.dart';
import 'package:provider/provider.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  String _selectedCity = 'Bangkok';
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    final provinceProvider = Provider.of<ProvinceProvider>(context);
    final selectedProvince = provinceProvider.selectProvince;

    if (selectedProvince != null &&
        (!_isInit || selectedProvince != _selectedCity)) {
      _selectedCity = selectedProvince;
      _isInit = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.wait([
          Provider.of<PollutionProvider>(context, listen: false)
              .fetchPollution(_selectedCity),
          Provider.of<WeatherProvider>(context, listen: false)
              .fetchWeatherData(_selectedCity)
        ]);
      });
    }
  }

  Future<void> _refreshData() async {
    await Future.wait([
      Provider.of<PollutionProvider>(context, listen: false)
          .fetchPollution(_selectedCity),
      Provider.of<WeatherProvider>(context, listen: false)
          .fetchWeatherData(_selectedCity)
    ]);
  }

  Widget build(BuildContext context) {
    //provider
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final pollutionProvider = Provider.of<PollutionProvider>(context);
    final authProvider = Provider.of<AuthenticationProvider>(context);
    if (weatherProvider.isLoading && pollutionProvider.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (weatherProvider.error != null ||
        pollutionProvider.error != null ) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Error: ${weatherProvider.error}',
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    } else if (weatherProvider.currentWeather != null &&
        pollutionProvider.currentPollution != null) {
      return SafeArea(
        child: Column(
          children: [
            MainAppBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WeatherDetailPage(
                                        weather: weatherProvider.currentWeather!,
                                        forecast:
                                            weatherProvider.forecastWeather!,
                                        hourly: weatherProvider.hourlyWeather,
                                      )));
                        },
                        child: buildWeatherCard(
                            weather: weatherProvider.currentWeather!),
                      ),
                      const SizedBox(height: 16),
                      //คุณภาพอากาศ
                      Airqualitycard(
                        currentPollution: pollutionProvider.currentPollution,
                        advicemodel: pollutionProvider.adviceModel,
                      ),
                      const SizedBox(height: 16),
                      //คำแนพนำสุขภาพ
                      _buildHealthCard(pollutionProvider.adviceModel!),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Text("No weather data available."),
      );
    }
  }

  Widget _buildHealthCard(Advicemodel advice) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'คำแนะนำสุขภาพ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildHealthTip(
            Icons.check_circle,
            advice.generalAdvice,
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildHealthTip(
            Icons.warning_amber_rounded,
            advice.sensitiveAdvice,
            Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTip(IconData icon, String text, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}
