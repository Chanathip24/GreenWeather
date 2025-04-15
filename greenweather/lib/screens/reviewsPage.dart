import 'package:flutter/material.dart';
import 'package:greenweather/model/reviewModel.dart';
import 'package:greenweather/providers/province_provider.dart';
import 'package:greenweather/providers/review_provider.dart';
import 'package:greenweather/screens/submitreportPage.dart';
import 'package:greenweather/widgets/Appbar.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  String? _previousProvince; // Store the previous province
  bool _isInit = false; //first time run

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final provinceProvider = Provider.of<ProvinceProvider>(context);
    final selectedProvince = provinceProvider.selectProvince;

    if (selectedProvince != null &&
        (!_isInit || selectedProvince != _previousProvince)) {
      _previousProvince = selectedProvince;
      _isInit = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Provider.of<ReviewProvider>(context, listen: false)
            .getAllReviews(selectedProvince);
      });
    }
  }

  Widget build(BuildContext context) {
    //provider
    final provinceProvider = Provider.of<ProvinceProvider>(context);
    final reviewProvider = Provider.of<ReviewProvider>(context);
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
                text: provinceProvider.selectProvince,
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
            icon: const Icon(Icons.refresh, color: Colors.black54),
            onPressed: () async {
              await Provider.of<ReviewProvider>(context, listen: false)
                  .getAllReviews(_previousProvince!);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          MainAppBar(),
          Expanded(
            // Add this Expanded widget around the RefreshIndicator
            child: RefreshIndicator(
              onRefresh: () async {
                await Provider.of<ReviewProvider>(context, listen: false)
                    .getAllReviews(_previousProvince!);
              },
              child: reviewProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : reviewProvider.reviews.isNotEmpty
                      ? ListView.builder(
                          itemCount: reviewProvider.reviews.length,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          itemBuilder: (context, index) {
                            final Reviewmodel review =
                                reviewProvider.reviews[index];
                            return ReviewCard(index: index, review: review);
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 60, color: Colors.red),
                              const SizedBox(height: 16),
                              Text(
                                'ไม่พบรีวิวในจังหวัดนี้',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ),
        ],
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
  final Reviewmodel review;
  const ReviewCard({super.key, required this.index, required this.review});

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
                  child: Icon(Icons.person_outline,
                      size: 18, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 12),
                // Username
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@${review.ownerName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${review.createdAt?.split('T')[0].split("-")[2]} ${_getMonth(int.parse(review.createdAt!.split('-')[1]))}',
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
              review.detail ?? "",
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
                    color: _getAqiColor(review.aqi ?? 0),
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
                        'AQI ${review.aqi}',
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
                  '${review.rating} คนเห็นด้วย',
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

  Color _getAqiColor(int aqi) {
    final List<Color> colors = [
      Colors.green.shade400,
      Colors.orange,
      Colors.amber.shade700,
      Colors.red.shade400,
      Colors.purple.shade400,
    ];
    if (aqi <= 50) {
      return colors[0];
    } else if (aqi <= 100) {
      return colors[1];
    } else if (aqi <= 150) {
      return colors[2];
    } else if (aqi <= 200) {
      return colors[3];
    } else {
      return colors[4];
    }
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
