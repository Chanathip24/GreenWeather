import 'package:flutter/material.dart';
import 'package:greenweather/model/adviceModel.dart';
import 'package:greenweather/model/pollutionModel.dart';

class AirQualityDetailPage extends StatelessWidget {
  final Pollutionmodel pollution;
  final Advicemodel advicemodel;

  const AirQualityDetailPage(
      {super.key, required this.pollution, required this.advicemodel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildImprovedAppBar(context, advicemodel),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMainCard(context, advicemodel),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildPollutantsSection(),
                    const SizedBox(height: 20),
                    _buildHealthAdviceSection(advicemodel),
                    const SizedBox(height: 20),
                    _buildMoreInfoSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildImprovedAppBar(
      BuildContext context, Advicemodel advice) {
    final Color status = advice.color;

    return AppBar(
      backgroundColor: status,
      elevation: 0,
      title: const Text(
        'รายละเอียดคุณภาพอากาศ',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildMainCard(BuildContext context, Advicemodel advice) {
    final status = advice.color;
    final size = MediaQuery.of(context).size;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: double.infinity,
      color: status,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          const SizedBox(height: 12),

          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                            begin: 0,
                            end: double.parse(pollution.aqi.toString())),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          advice.status,
                          key: ValueKey(advice.status),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          // Status description container
          AnimatedSlide(
            offset: const Offset(0, 0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutQuart,
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeIn,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  advice.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          const SizedBox(height: 20),
          // Time update indicator
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'อัปเดตล่าสุด: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} น.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildPollutantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('สารมลพิษหลัก', Icons.air),
        const SizedBox(height: 12),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildSimplePollutantCard('PM2.5',
                      pollution.pm25.toString(), 'μg/m³', Colors.blue[700]!),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSimplePollutantCard('PM10',
                      pollution.pm10.toString(), 'μg/m³', Colors.indigo[700]!),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSimplePollutantCard('SO₂',
                      pollution.so2.toString(), 'μg/m³', Colors.purple[700]!),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSimplePollutantCard('NO₂',
                      pollution.no2.toString(), 'μg/m³', Colors.amber[800]!),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSimplePollutantCard(
      String name, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.green[800], size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthAdviceSection(Advicemodel advice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('คำแนะนำด้านสุขภาพ', Icons.health_and_safety),
          const SizedBox(height: 16),
          _buildSimpleAdviceItem(
            'ทั่วไป',
            advice.generalAdvice,
            Icons.person,
          ),
          const Divider(height: 24),
          _buildSimpleAdviceItem(
            'กลุ่มเสี่ยง',
            advice.sensitiveAdvice,
            Icons.elderly,
          ),
          const Divider(height: 24),
          _buildSimpleAdviceItem(
            'กิจกรรมกลางแจ้ง',
            advice.outdoorAdvice,
            Icons.directions_run,
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleAdviceItem(String title, String advice, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.green[800], size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            advice,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoreInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('ข้อมูลเพิ่มเติม', Icons.info_outline),
          const SizedBox(height: 16),
          Text(
            'ดัชนีคุณภาพอากาศ (AQI) คือการวัดว่าอากาศมีมลพิษมากเพียงใด ยิ่งค่า AQI สูง ยิ่งแสดงถึงระดับมลพิษที่อาจส่งผลเสียต่อสุขภาพ',
            style:
                TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
          ),
          const SizedBox(height: 12),
          Text(
            'ค่า AQI นี้คำนวณจากค่าเฉลี่ยของหลายตัวบ่งชี้มลพิษ รวมถึง PM2.5, PM10, O₃, NO₂, SO₂ และ CO',
            style:
                TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'ระดับคุณภาพอากาศ:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildAqiScaleRows(),
        ],
      ),
    );
  }

  Widget _buildAqiScaleRows() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildSimpleAqiScale('0-50', 'ดี', Colors.green)),
            const SizedBox(width: 8),
            Expanded(
                child: _buildSimpleAqiScale(
                    '51-100', 'ปานกลาง', Colors.amber[800]!)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: _buildSimpleAqiScale(
                    '101-150', 'กลุ่มเสี่ยง', Colors.orange)),
            const SizedBox(width: 8),
            Expanded(
                child: _buildSimpleAqiScale('151-200', 'ไม่ดี', Colors.red)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child:
                    _buildSimpleAqiScale('201-300', 'แย่มาก', Colors.purple)),
            const SizedBox(width: 8),
            Expanded(
                child: _buildSimpleAqiScale('300+', 'อันตราย', Colors.brown)),
          ],
        ),
      ],
    );
  }

  Widget _buildSimpleAqiScale(String range, String quality, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  range,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  quality,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
