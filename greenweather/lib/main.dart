import 'package:flutter/material.dart';
import 'package:greenweather/screens/leaderboardPage.dart';
import 'package:greenweather/screens/loginPage.dart';

//screen
import 'package:greenweather/screens/mainScreen.dart';
import 'package:greenweather/screens/reviewsPage.dart';
import 'package:greenweather/screens/submitreportPage.dart';
//component
import 'widgets/Navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Kanit',
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  int _selectedPage = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Navbar(
        selectedindex: _selectedPage,
        onItemTapped: _onItemTapped,
      ),
      body: IndexedStack(
        index: _selectedPage,
        children: [
          Mainscreen(),
          ReviewPage(),
          AirQualityForm(),
          Leaderboardpage(),
          LoginPage(),
        ],
      ),
    );
  }
}
