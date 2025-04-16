import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:greenweather/model/reviewLikeModel.dart';
import 'package:greenweather/model/reviewModel.dart';
import 'package:greenweather/model/userModel.dart';
import 'package:greenweather/providers/authentication_provider.dart';
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
  Usermodel? _previousUserdata;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    final provinceProvider = Provider.of<ProvinceProvider>(context);
    final authProvider = Provider.of<AuthenticationProvider>(context);

    //current data
    final selectedProvince = provinceProvider.selectProvince;
    final Usermodel? user = authProvider.userdata;

    bool provinceChange = selectedProvince != null &&
        (!_isInit || selectedProvince != _previousProvince);
    bool userChange = _previousUserdata?.id != user?.id;
    if (provinceChange || userChange) {
      _previousProvince = selectedProvince;
      _previousUserdata = user;
      _isInit = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          await Future.wait([
            Provider.of<ReviewProvider>(context, listen: false).userLike(),
            Provider.of<ReviewProvider>(context, listen: false)
                .getAllReviews(selectedProvince)
          ]);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load reviews: ${e.toString()}')),
          );
        }
      });
    }
  }

  Future<void> _refreshData() async {
    if (_previousProvince == null) return;

    try {
      await Future.wait([
        Provider.of<ReviewProvider>(context, listen: false).userLike(),
        Provider.of<ReviewProvider>(context, listen: false)
            .getAllReviews(_previousProvince!)
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to refresh data: ${e.toString()}')),
        );
      }
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
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Column(
        children: [
          MainAppBar(),
          Expanded(
            // Add this Expanded widget around the RefreshIndicator
            child: RefreshIndicator(
              onRefresh: _refreshData,
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
                            return ReviewCard(
                              index: index,
                              review: review,
                              reviewProvider: reviewProvider,
                              onLikechange: _refreshData,
                            );
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AirQualityForm(
                        isPop: true,
                      ))).then((_) => _refreshData());
        },
      ),
    );
  }
}

class ReviewCard extends StatefulWidget {
  final int index;
  final Reviewmodel review;
  final ReviewProvider? reviewProvider;
  final VoidCallback? onLikechange;
  const ReviewCard(
      {super.key,
      required this.index,
      required this.review,
      this.reviewProvider,
      this.onLikechange});

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  @override
  late bool _isLike;
  bool _isProcessingLike = false;
  @override
  void initState() {
    super.initState();
    _updateLikeStatus();
  }

  @override
  void didUpdateWidget(ReviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateLikeStatus();
  }

  //get like status
  void _updateLikeStatus() {
    if (widget.reviewProvider == null) {
      _isLike = false;
      return;
    }
    final findLikeIndex = widget.reviewProvider?.userLikedata
        .indexWhere((post) => post.reviewId == widget.review.id);

    _isLike = findLikeIndex != -1;

    //update model
    if (widget.review.isLike != _isLike) {
      widget.review.isLike = _isLike;
    }
  }

  Future<void> _toggleLike() async {
    if (_isProcessingLike) return;
    AuthenticationProvider authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    bool isAuthenticate = authProvider.isAuthenticate;

    if (!isAuthenticate) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("กรุณาเข้าสู่ระบบ"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    setState(() {
      _isProcessingLike = true; //รอโหลดแปป
      _isLike = !_isLike;
      widget.review.isLike = _isLike; // อัปเดตค่าใน object
    });

    try {
      if (_isLike) {
        await widget.reviewProvider?.saveLike(
          Reviewlikemodel(reviewId: widget.review.id!),
        );
      } else {
        await widget.reviewProvider?.deleteLike(
          Reviewlikemodel(reviewId: widget.review.id!),
        );
      }

      // Call onLikeChanged
      widget.onLikechange?.call();
    } catch (e) {
      // Revert the like status if an error occurred
      setState(() {
        _isLike = !_isLike;
        widget.review.isLike = _isLike;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to update like status: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingLike = false;
        });
      }
    }
  }

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
                      '@${widget.review.ownerName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.review.createdAt?.split('T')[0].split("-")[2]} ${_getMonth(int.parse(widget.review.createdAt!.split('-')[1]))}',
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
                  icon: _isProcessingLike
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.grey.shade700),
                        )
                      : Icon(
                          _isLike ? Icons.favorite : Icons.favorite_border,
                          size: 22,
                          color: _isLike ? Colors.red : Colors.grey.shade700,
                        ),
                  onPressed: _toggleLike,
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
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
              widget.review.detail ?? "",
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
                    color: _getAqiColor(widget.review.aqi ?? 0),
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
                        'AQI ${widget.review.aqi}',
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
                        _getWeatherIcon(widget.index),
                        size: 14,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getWeatherText(widget.index),
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
                  '${widget.review.rating} คนเห็นด้วย',
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
