import 'package:flutter/material.dart';
import 'package:greenweather/model/userModel.dart';
import 'package:greenweather/providers/authentication_provider.dart';
import 'package:greenweather/screens/edituserpage.dart';
import 'package:greenweather/screens/loginPage.dart';
import 'package:greenweather/screens/rewardPage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

//model
import '../model/activityModel.dart';

class GreenUserProfilePage extends StatefulWidget {
  final Usermodel? user;
  const GreenUserProfilePage({super.key, required this.user});

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

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('ยืนยันออกจากระบบ'),
          content: const Text('คุณต้องการออกจากระบบใช่หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ยกเลิก', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final authProvider =
                    Provider.of<AuthenticationProvider>(context, listen: false);
                await authProvider.logout();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('ออกจากระบบเรียบร้อยแล้ว'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child:
                  const Text('ออกจากระบบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = isDark ? Colors.green.shade300 : Colors.green.shade600;
    final backgroundColor = isDark ? colorScheme.surface : Colors.grey.shade50;

    return authProvider.isAuthenticate
        ? Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                'โปรไฟล์',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout_rounded),
                  tooltip: 'ออกจากระบบ',
                  onPressed: _showLogoutConfirmation,
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),

                      // User profile section
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: primaryColor.withOpacity(0.2),
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'คุณ ${widget.user?.fname}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${widget.user?.email}",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Chip(
                        avatar: Icon(Icons.eco, color: primaryColor, size: 18),
                        label: Text(
                          'ระดับ Eco Warrior',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: primaryColor.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                      ),

                      const SizedBox(height: 24),

                      // Points Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryColor,
                              primaryColor.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.stars_rounded,
                                    color: Colors.white, size: 32),
                                const SizedBox(width: 12),
                                Text(
                                  '${widget.user?.points}',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'แต้มสะสมของคุณ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RewardPage()),
                                );
                              },
                              icon: const Icon(Icons.redeem),
                              label: const Text('แลกรางวัล'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: primaryColor,
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Activity Tabs
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? colorScheme.surface : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            TabBar(
                              controller: _tabController,
                              tabs: const [
                                Tab(text: 'กิจกรรมล่าสุด'),
                                Tab(text: 'สถิติของฉัน'),
                              ],
                              labelColor: primaryColor,
                              unselectedLabelColor: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                              indicatorColor: primaryColor,
                              indicatorSize: TabBarIndicatorSize.label,
                              dividerColor: Colors.transparent,
                            ),
                            SizedBox(
                              height: 300,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  // Recent Activities Tab
                                  _activities.isEmpty
                                      ? const Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.history,
                                                  size: 48, color: Colors.grey),
                                              SizedBox(height: 16),
                                              Text(
                                                'ยังไม่มีกิจกรรมล่าสุด',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        )
                                      : ListView.separated(
                                          padding: const EdgeInsets.all(16),
                                          itemCount: _activities.length,
                                          separatorBuilder: (context, index) =>
                                              Divider(
                                            height: 1,
                                            color: Colors.grey.withOpacity(0.2),
                                          ),
                                          itemBuilder: (context, index) {
                                            final activity = _activities[index];
                                            return ActivityListItem(
                                                activity: activity);
                                          },
                                        ),

                                  // Statistics Tab
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'สถิติการใช้งาน',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          width: double.infinity,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            color:
                                                primaryColor.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: const Center(
                                            child: Text(
                                                'กราฟแสดงสถิติจะอยู่ที่นี่'),
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

                      const SizedBox(height: 24),

                      // Account Settings Section
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isDark ? colorScheme.surface : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.person_outline,
                                  color: primaryColor),
                              title: const Text('แก้ไขโปรไฟล์'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                // Navigate to edit profile
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditProfilePage(
                                              user: widget.user!,
                                            )));
                              },
                            ),
                            Divider(
                                height: 1, color: Colors.grey.withOpacity(0.2)),
                            ListTile(
                              leading: const Icon(Icons.logout_rounded,
                                  color: Colors.red),
                              title: const Text('ออกจากระบบ',
                                  style: TextStyle(color: Colors.red)),
                              onTap: _showLogoutConfirmation,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          )
        : LoginPage();
  }
}

class ActivityListItem extends StatelessWidget {
  final ActivityItem activity;

  const ActivityListItem({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEE, d/M').format(activity.date);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pointColor = activity.isPositive ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: pointColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activity.isPositive
                  ? Icons.add_circle_outline
                  : Icons.remove_circle_outline,
              color: pointColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${activity.isPositive ? '+' : '-'}${activity.points}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: pointColor,
            ),
          ),
        ],
      ),
    );
  }
}
