import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenweather/model/weatherModel.dart';
import 'package:greenweather/providers/weather_provider.dart';
import 'package:greenweather/screens/forecastPage.dart';
import 'package:greenweather/screens/weatherDetailPage.dart';
import 'package:greenweather/widgets/Appbar.dart';
import 'package:greenweather/widgets/Weathercard.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  String _selectedCity = 'Bangkok';
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<WeatherProvider>(context, listen: false)
        .fetchWeatherData(_selectedCity));
  }

  Widget build(BuildContext context) {
    //provider
    final weatherProvider = Provider.of<WeatherProvider>(context);

    if (weatherProvider.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (weatherProvider.error != null) {
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
    } else if (weatherProvider.currentWeather != null) {
      return SafeArea(
        child: Column(
          children: [
            MainAppBar(
              weatherProvider: weatherProvider,
            ),
            Expanded(
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
                                    )));
                      },
                      child: buildWeatherCard(
                          weather: weatherProvider.currentWeather!),
                    ),
                    const SizedBox(height: 16),
                    _buildAirQualityCard(),
                    const SizedBox(height: 16),
                    _buildHealthCard(),
                    const SizedBox(height: 16),
                    _buildFutureForecastButton(),
                  ],
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

  Widget _buildWeatherCard(WeatherModel weather) {
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
                  child: _getWeatherIcon(weather.main),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildWeatherInfoItem(
                Icons.water_drop,
                'ความชื้น',
                "${weather.humidity}%",
                Colors.blue,
              ),
              _buildWeatherInfoItem(
                Icons.air,
                'ลม',
                '${weather.windSpeed} กม./ชม.',
                Colors.blue[300]!,
              ),
              _buildWeatherInfoItem(
                Icons.thermostat,
                'ความรู้สึก',
                '${weather.feel_likes.toInt().toString()}°C',
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfoItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildAirQualityCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'คุณภาพอากาศ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'รายละเอียด',
                style: TextStyle(fontSize: 14, color: Colors.green[400]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.green[400],
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '75',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ปานกลาง',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'คุณภาพอากาศเหมาะสมสำหรับคนทั่วไป',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAirQualityItem('PM2.5', '25', 'μg/m³'),
              _buildAirQualityItem('PM10', '38', 'μg/m³'),
              _buildAirQualityItem('SO₂', '42', 'ppb'),
              _buildAirQualityItem('NO₂', '15', 'ppb'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAirQualityItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(unit, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildHealthCard() {
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
            'เหมาะสมสำหรับกิจกรรมกลางแจ้งทั่วไป',
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildHealthTip(
            Icons.warning_amber_rounded,
            'กลุ่มเสี่ยง เช่น ผู้ป่วยโรคระบบทางเดินหายใจควรหลีกเลี่ยงการทำกิจกรรมกลางแจ้งที่ใช้แรงมาก',
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

  Widget _buildFutureForecastButton() {
    return ElevatedButton(
      onPressed: () {
        //page route ไปที่ forecast page
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ForecastPage()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Text(
        'สภาพอากาศในอนาคต',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

Widget _getWeatherIcon(String weatherMain) {
  final Map<String, IconData> weatherIcons = {
    'clear': Icons.wb_sunny_outlined,
    'clouds': Icons.cloud_outlined,
    'rain': Icons.water_drop_outlined,
    'snow': Icons.ac_unit_outlined,
    'thunderstorm': Icons.bolt_outlined,
    'drizzle': Icons.grain_outlined,
    'mist': Icons.cloud_outlined,
    'fog': Icons.cloud_outlined,
    'haze': Icons.cloud_outlined,
  };

  final Map<String, Color> weatherColors = {
    'clear': Colors.amber[600]!,
    'clouds': Colors.blueGrey[400]!,
    'rain': Colors.blue[400]!,
    'snow': Colors.lightBlue[100]!,
    'thunderstorm': Colors.deepPurple[400]!,
    'drizzle': Colors.lightBlue[300]!,
    'mist': Colors.blueGrey[300]!,
    'fog': Colors.blueGrey[200]!,
    'haze': Colors.blueGrey[300]!,
  };

  final String weatherType = weatherMain.toLowerCase();
  final IconData iconData = weatherIcons[weatherType] ?? Icons.help_outline;
  final Color iconColor = weatherColors[weatherType] ?? Colors.grey;

  return Container(
    decoration: BoxDecoration(
      color: iconColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(50),
    ),
    padding: const EdgeInsets.all(12),
    child: Icon(
      iconData,
      color: iconColor,
      size: 48,
    ),
  );
}
