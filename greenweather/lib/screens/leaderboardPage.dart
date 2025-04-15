import 'package:flutter/material.dart';
import 'package:greenweather/model/userModel.dart';
import 'package:greenweather/providers/authentication_provider.dart';
import 'package:greenweather/providers/userlist_provider.dart';
import 'package:greenweather/screens/loginPage.dart';
import 'package:provider/provider.dart';

class Leaderboardpage extends StatefulWidget {
  const Leaderboardpage({super.key});

  @override
  State<Leaderboardpage> createState() => _LeaderboardpageState();
}

class _LeaderboardpageState extends State<Leaderboardpage> {
  Usermodel? _userdata;
  bool _isInit = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadUserList();
    });
  }

  Future<void> _loadUserList() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<UserlistProvider>(context, listen: false).getAllUser();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final AuthenticationProvider authenticationProvider =
        Provider.of<AuthenticationProvider>(context);
    final curuser = authenticationProvider.userdata;

    if (curuser != null && (!_isInit || curuser != _userdata)) {
      _userdata = curuser;
      _isInit = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadUserList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationProvider authProvider =
        Provider.of<AuthenticationProvider>(context);
    final UserlistProvider userlistProvider =
        Provider.of<UserlistProvider>(context);

    // Get all user data
    final List<Usermodel> userList = List.from(userlistProvider.usersList)
      ..sort((a, b) => (b.points ?? 0).compareTo(a.points ?? 0));

    // Check if current user exists
    final userIndex = authProvider.isAuthenticate == true
        ? userList.indexWhere((user) => user.id == authProvider.userdata?.id)
        : -1;

    int getPointsToNextRank(String id) {
      // Find user's ตำแหน่ง
      int index = userList.indexWhere((user) => user.id == id);

      // User not found
      if (index == -1) return 0;

      // ที่ 1
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    if (authProvider.isAuthenticate == true && userIndex != -1)
                      Userstatscard(
                          userRank: userIndex + 1,
                          userPoints: userList[userIndex].points ?? 0,
                          pointsToNextRank: getPointsToNextRank(
                              authProvider.userdata?.id ?? "")),

                    if (authProvider.isAuthenticate != true)
                      GuestUserCard(
                        onSignIn: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage(
                                        isPop: true,
                                      )));
                        },
                      ),

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

                    if (userList.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            'No participants yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      )
                    else
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
                  ],
                ),
              ),
            ),
    );
  }
}

class GuestUserCard extends StatelessWidget {
  final VoidCallback onSignIn;

  const GuestUserCard({
    Key? key,
    required this.onSignIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade100, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Join the Leaderboard!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sign in to track your progress and compete with others',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onSignIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Sign In'),
          ),
        ],
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
    final double progress = (userPoints + pointsToNextRank) > 0
        ? userPoints / (userPoints + pointsToNextRank)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade100, Colors.green.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
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
              value: progress,
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
              : const Text(
                  'You are the top participant!',
                  style: TextStyle(fontSize: 14),
                ),
        ],
      ),
    );
  }
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Rank indicator
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: medalColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: medalColor.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '$rank',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: rank <= 3 ? Colors.white : Colors.black87,
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
                  user.fname != null && user.lname != null
                      ? "@${user.fname} ${user.lname}"
                      : "User",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // Points
                    _buildStatChip(
                        Icons.star_border, "${user.points ?? 0} pts"),
                  ],
                ),
              ],
            ),
          ),

          // Points
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              "${user.points ?? 0}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
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
