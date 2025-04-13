import 'package:flutter/material.dart';

//lib
import 'package:flutter_dotenv/flutter_dotenv.dart'; //env
import 'package:greenweather/providers/authentication_provider.dart';
import 'package:greenweather/providers/pollution_provider.dart';
import 'package:greenweather/providers/province_provider.dart';
import 'package:greenweather/providers/weather_provider.dart';
//screen
import 'package:greenweather/screens/mainScreen.dart';
import 'package:greenweather/screens/reviewsPage.dart';
import 'package:greenweather/screens/submitreportPage.dart';
import 'package:greenweather/screens/leaderboardPage.dart';
import 'package:greenweather/screens/loginPage.dart';
import 'package:provider/provider.dart';
//component
import 'widgets/Navbar.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WeatherProvider()),
        ChangeNotifierProvider(create: (context) => ProvinceProvider()),
        ChangeNotifierProvider(create: (context) => PollutionProvider()),
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
      home: WeatherScreen(),
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
