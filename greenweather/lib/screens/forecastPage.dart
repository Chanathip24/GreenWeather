import 'package:flutter/material.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  State<ForecastPage> createState() => ForecastPageState();
}

class ForecastPageState extends State<ForecastPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Forecast"),
      ),
      body: SafeArea(
          child: Column(
        children: [Text("Forecastpage")],
      )),
    );
  }
}
