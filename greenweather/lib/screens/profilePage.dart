import 'package:flutter/material.dart';
import 'package:greenweather/screens/rewardPage.dart';
import 'package:greenweather/widgets/Appbar.dart';
import 'package:intl/intl.dart';

class GreenUserProfilePage extends StatefulWidget {
  const GreenUserProfilePage({super.key});

  @override
  State<GreenUserProfilePage> createState() => _GreenUserProfilePageState();
}

class _GreenUserProfilePageState extends State<GreenUserProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<ActivityItem> _activities = [
    ActivityItem(
      title: 'รางวัลพลังงาน',
      date: DateTime.now().subtract(const Duration(days: 1)),
      points: 15,
      isPositive: true,
    ),
    ActivityItem(
      title: 'รางวัลพลังงาน',
      date: DateTime.now().subtract(const Duration(days: 6)),
      points: 15,
      isPositive: true,
    ),
    ActivityItem(
      title: 'ร่วมแคมเปญ ลดการใช้พลังงาน',
      date: DateTime.now().subtract(const Duration(days: 10)),
      points: 50,
      isPositive: true,
    ),
    ActivityItem(
      title: 'แลกของรางวัล - บัตรกำนัลมูลค่า 100 บาท',
      date: DateTime.now().subtract(const Duration(days: 12)),
      points: 200,
      isPositive: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'โปรไฟล์ของฉัน',
          style: TextStyle(
            color: Colors.green,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // User Info Card
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'profile-image',
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey.shade300,
                            child: const Icon(Icons.person,
                                size: 50, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'คุณ Green User',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '@greenUser',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.eco,
                                      color: Colors.green, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    'ระดับ Eco Warrior',
                                    style: TextStyle(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () {},
                          tooltip: 'Edit Profile',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Points Card
                Card(
                  elevation: 3,
                  color: isDark ? Colors.green.shade800 : Colors.green.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.eco, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              '1,240 แต้ม',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : Colors.green.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'แต้มสะสมของคุณ',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                isDark ? Colors.white70 : Colors.green.shade600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RewardPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                isDark ? Colors.green.shade900 : Colors.white,
                            backgroundColor: isDark
                                ? Colors.green.shade400
                                : Colors.green.shade600,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.redeem),
                              SizedBox(width: 8),
                              Text('แลกรางวัล'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Activity Tabs
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'กิจกรรมล่าสุด'),
                          Tab(text: 'สถิติของฉัน'),
                        ],
                        labelColor: Colors.green,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.green,
                      ),
                      SizedBox(
                        height: 300,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Recent Activities Tab
                            ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: _activities.length,
                              itemBuilder: (context, index) {
                                final activity = _activities[index];
                                return ActivityListItem(activity: activity);
                              },
                            ),

                            // Statistics Tab
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'สถิติการใช้งาน',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text('กราฟแสดงสถิติที่นี่'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ActivityItem {
  final String title;
  final DateTime date;
  final int points;
  final bool isPositive;

  ActivityItem({
    required this.title,
    required this.date,
    required this.points,
    required this.isPositive,
  });
}

class ActivityListItem extends StatelessWidget {
  final ActivityItem activity;

  const ActivityListItem({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEE, d/M').format(activity.date);

    return ListTile(
      leading: Icon(activity.isPositive ? Icons.add : Icons.remove,
          color: activity.isPositive ? Colors.green : Colors.red),
      title: Text(activity.title),
      subtitle: Text(formattedDate),
      trailing: Text('${activity.isPositive ? '+' : '-'}${activity.points}'),
    );
  }
}
