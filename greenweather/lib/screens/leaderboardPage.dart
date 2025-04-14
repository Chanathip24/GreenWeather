import 'package:flutter/material.dart';
import 'package:greenweather/model/userModel.dart';
import 'package:greenweather/providers/authentication_provider.dart';
import 'package:greenweather/providers/userlist_provider.dart';
import 'package:provider/provider.dart';

// The LeaderboardScreen class that only returns a Scaffold
class Leaderboardpage extends StatefulWidget {
  const Leaderboardpage({super.key});

  @override
  State<Leaderboardpage> createState() => _LeaderboardpageState();
}

class _LeaderboardpageState extends State<Leaderboardpage> {
  int userPoints = 820;
  int userRank = 5;
  int pointsToNextRank = 3000;

  @override
  void initState() {
    super.initState();
    // Fetch user data when the widget is initialized
    Future.microtask(() async {
      await Provider.of<UserlistProvider>(context, listen: false).getAllUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationProvider authProvider =
        Provider.of<AuthenticationProvider>(context);
    final UserlistProvider _userlistProvider =
        Provider.of<UserlistProvider>(context);

    //all user data
    final List<Usermodel> userList = _userlistProvider.usersList;
    int getReachRank(String id) {
      // หาตำแหน่งใน list
      int index = userList.indexWhere((user) => user.id == id);

      // หาไม่เจอ
      if (index == -1) return 0;

      //ที่ 1
      if (index == 0) return 0;

      final Usermodel currentUser = userList[index];
      final Usermodel userAhead = userList[index - 1];

      int currentPoints = currentUser.points ?? 0;
      int aheadPoints = userAhead.points ?? 0;

      return aheadPoints - currentPoints + 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Leaderboard',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // User stats card
              authProvider.isAuthenticate == true
                  ? Userstatscard(
                      userRank: userList.indexWhere(
                              (user) => user.id == authProvider.userdata?.id) +
                          1,
                      userPoints: userList[userList.indexWhere(
                              (user) => user.id == authProvider.userdata?.id)]
                          .points!,
                      pointsToNextRank:
                          getReachRank(authProvider.userdata?.id ?? ""))
                  : SizedBox(),

              const SizedBox(height: 24),

              // Leaderboard title
              const Row(
                children: [
                  Text(
                    'Top Participants',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Leaderboard entries
              Expanded(
                child: ListView.separated(
                  itemCount: userList.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = userList[index];
                    return LeaderboardTile(
                      rank: index + 1,
                      user: user,
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class Userstatscard extends StatelessWidget {
  const Userstatscard({
    super.key,
    required this.userRank,
    required this.userPoints,
    required this.pointsToNextRank,
  });

  final int userRank;
  final int userPoints;
  final int pointsToNextRank;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade100, Colors.green.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Rank: #$userRank',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$userPoints points',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: userPoints / (userPoints + pointsToNextRank),
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.5),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          userRank > 1
              ? Text(
                  '$pointsToNextRank more points to reach rank #${userRank - 1}',
                  style: const TextStyle(fontSize: 14),
                )
              : Text(
                  'You are the top participant!',
                  style: const TextStyle(fontSize: 14),
                ),
        ],
      ),
    );
  }
}

class LeaderboardEntry {
  final String username;
  final int points;
  final int reviews;
  final int photos;
  final int consecutiveDays;

  LeaderboardEntry({
    required this.username,
    required this.points,
    required this.reviews,
    required this.photos,
    required this.consecutiveDays,
  });
}

class LeaderboardTile extends StatelessWidget {
  final int rank;
  final Usermodel user;

  const LeaderboardTile({
    Key? key,
    required this.rank,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set medal colors for top 3
    Color? medalColor;
    if (rank == 1)
      medalColor = Colors.amber;
    else if (rank == 2)
      medalColor = Colors.grey.shade400;
    else if (rank == 3)
      medalColor = Colors.brown.shade300;
    else
      medalColor = Colors.green.shade200;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          // Rank indicator
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: medalColor ?? Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$rank',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: medalColor != null ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "@${user.fname} ${user.lname}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // Reviews
                    _buildStatChip(Icons.rate_review, user.points.toString()),

                    const SizedBox(width: 16),

                    // Photos
                    _buildStatChip(Icons.photo, user.points.toString()),

                    const SizedBox(width: 16),

                    // Consecutive Days
                    _buildStatChip(
                        Icons.calendar_today, user.points.toString()),
                  ],
                ),
              ],
            ),
          ),

          // Points
          Text(
            user.points.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
