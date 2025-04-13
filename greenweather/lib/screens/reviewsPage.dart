import 'package:flutter/material.dart';
import 'package:greenweather/providers/province_provider.dart';
import 'package:greenweather/screens/submitreportPage.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provinceProvider = Provider.of<ProvinceProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'รีวิวยอดนิยมใน ',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              TextSpan(
                text: provinceProvider.selectProvince ?? 'จังหวัด',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 4,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemBuilder: (context, index) {
          return ReviewCard(index: index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AirQualityForm()));
        },
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final int index;

  const ReviewCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info and actions row
            Row(
              children: [
                // User avatar
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade200,
                  child: Text(
                    'U${index + 1}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Username
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@user${1234 + index}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${DateTime.now().day - index} ${_getMonth(DateTime.now().month)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Like button
                IconButton(
                  icon: const Icon(
                    Icons.favorite_border,
                    size: 22,
                  ),
                  onPressed: () {},
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  color: Colors.grey.shade700,
                ),
                const SizedBox(width: 12),
                // Share button
                IconButton(
                  icon: const Icon(
                    Icons.share_outlined,
                    size: 20,
                  ),
                  onPressed: () {},
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  color: Colors.grey.shade700,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Review content
            Text(
              _getReviewText(index),
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),

            const SizedBox(height: 12),

            // Rating and tags
            Row(
              children: [
                // AQI indicator
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getAqiColor(index),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.air,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'AQI ${110 + (index * 10)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Weather tag
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getWeatherIcon(index),
                        size: 14,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getWeatherText(index),
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  '${20 - (index * 5)} คนเห็นด้วย',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getReviewText(int index) {
    final List<String> reviews = [
      'อากาศดีและบริการประทับใจมาก ทางเดินเล่นริมหาดสะอาด บรรยากาศดี เหมาะกับการพักผ่อนในวันหยุด',
      'สภาพอากาศวันนี้ค่อนข้างร้อน แต่คุณภาพอากาศโดยรวมดี ลมพัดเย็นสบายในช่วงเย็น',
      'ฝนตกหนักในช่วงบ่าย แต่อากาศเย็นสบายหลังฝนหยุด น้ำไม่ท่วมขังบริเวณถนนหลัก',
      'อากาศแห้งมาก ควรพกน้ำติดตัวและหลีกเลี่ยงอยู่กลางแจ้งนานๆ ในช่วงกลางวัน',
    ];
    return reviews[index % reviews.length];
  }

  String _getMonth(int month) {
    const List<String> months = [
      'ม.ค.',
      'ก.พ.',
      'มี.ค.',
      'เม.ย.',
      'พ.ค.',
      'มิ.ย.',
      'ก.ค.',
      'ส.ค.',
      'ก.ย.',
      'ต.ค.',
      'พ.ย.',
      'ธ.ค.'
    ];
    return months[month - 1];
  }

  Color _getAqiColor(int index) {
    final List<Color> colors = [
      Colors.orange,
      Colors.amber.shade700,
      Colors.red.shade400,
      Colors.purple.shade400,
    ];
    return colors[index % colors.length];
  }

  IconData _getWeatherIcon(int index) {
    final List<IconData> icons = [
      Icons.wb_sunny_outlined,
      Icons.cloud_outlined,
      Icons.grain,
      Icons.thermostat,
    ];
    return icons[index % icons.length];
  }

  String _getWeatherText(int index) {
    final List<String> weather = [
      'แดดจัด',
      'มีเมฆมาก',
      'ฝนตก',
      'ร้อนมาก',
    ];
    return weather[index % weather.length];
  }
}
