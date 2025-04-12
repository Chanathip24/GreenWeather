import 'package:flutter/material.dart';
import 'package:greenweather/model/adviceModel.dart';
import 'package:greenweather/model/pollutionModel.dart';
import 'package:greenweather/screens/pollutionDetailpage.dart';

class Airqualitycard extends StatelessWidget {
  final Pollutionmodel? currentPollution;
  final Advicemodel? advicemodel;
  const Airqualitycard({super.key, required this.currentPollution, required this.advicemodel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> AirQualityDetailPage(pollution: currentPollution!,advicemodel: advicemodel!,)));
      },
      child: Container(
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
                    color: getStatus(currentPollution!.aqi)['color'],
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    currentPollution!.aqi.toString(),
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
                      Text(
                        getStatus(currentPollution!.aqi)['status'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        getStatus(currentPollution!.aqi)['description'],
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
                _buildAirQualityItem(
                    'PM2.5', currentPollution!.pm25.toString(), 'μg/m³'),
                _buildAirQualityItem(
                    'PM10', currentPollution!.pm10.toString(), 'μg/m³'),
                _buildAirQualityItem(
                    'SO₂', currentPollution!.so2.toString(), 'μg/m³'),
                _buildAirQualityItem(
                    'NO₂', currentPollution!.no2.toString(), 'μg/m³'),
              ],
            ),
          ],
        ),
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
}

Map<String, dynamic> getStatus(int aqi) {
  if (aqi <= 50) {
    return {
      "status": "ดี",
      "description": "คุณภาพอากาศเหมาะสมสำหรับคนทั่วไป",
      "color": Colors.green
    };
  } else if (aqi <= 100) {
    return {
      "status": "ปานกลาง",
      "description": "คุณภาพอากาศพอใช้ได้ แต่บางคนอาจเริ่มรู้สึกระคายเคือง",
      "color": Colors.yellow
    };
  } else if (aqi <= 150) {
    return {
      "status": "ไม่ดีต่อกลุ่มเสี่ยง",
      "description": "ผู้ป่วย เด็ก และผู้สูงอายุควรลดกิจกรรมกลางแจ้ง",
      "color": Colors.orange
    };
  } else if (aqi <= 200) {
    return {
      "status": "ไม่ดี",
      "description": "ทุกคนควรหลีกเลี่ยงกิจกรรมกลางแจ้ง",
      "color": Colors.red
    };
  } else if (aqi <= 300) {
    return {
      "status": "แย่มาก",
      "description": "อันตรายต่อสุขภาพ ควรอยู่ภายในอาคาร",
      "color": Colors.purple
    };
  } else {
    return {
      "status": "อันตราย",
      "description": "อากาศเป็นอันตรายมาก หลีกเลี่ยงกิจกรรมนอกบ้านโดยเด็ดขาด",
      "color": Colors.brown
    };
  }
}
