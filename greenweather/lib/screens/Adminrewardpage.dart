import 'package:flutter/material.dart';
import 'package:greenweather/model/Rewardmodel.dart';

import 'package:greenweather/providers/reward_provider.dart';
import 'package:greenweather/screens/AdminAddReward.dart';

import 'package:greenweather/screens/AdminAddrewardItem.dart';
import 'package:provider/provider.dart';

class AdminRewardsListPage extends StatefulWidget {
  const AdminRewardsListPage({super.key});

  @override
  State<AdminRewardsListPage> createState() => _AdminRewardsListPageState();
}

class _AdminRewardsListPageState extends State<AdminRewardsListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRewards();
    });
  }

  Future<void> _loadRewards() async {
    RewardProvider rewardProvider =
        Provider.of<RewardProvider>(context, listen: false);
    await rewardProvider.getRewards();
  }

  Future<void> _deleteReward(int rewardId) async {}

  void _showDeleteConfirmation(Reward reward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${reward.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteReward(reward.id);
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rewardProvider = Provider.of<RewardProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? Colors.green.shade300 : Colors.green.shade600;
    final backgroundColor =
        isDark ? Theme.of(context).colorScheme.surface : Colors.grey.shade50;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'จัดการรางวัล',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddEditRewardPage()));
        },
      ),
      body: SafeArea(
        child: rewardProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadRewards,
                child: rewardProvider.rewardData.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.card_giftcard,
                                size: 64, color: Colors.grey.withOpacity(0.5)),
                            const SizedBox(height: 16),
                            Text(
                              'ไม่มีรางวัลในระบบ',
                              style: TextStyle(
                                  color: Colors.grey.withOpacity(0.8)),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddEditRewardPage()));
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('เพิ่มรางวัลใหม่'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: rewardProvider.rewardData.length,
                        itemBuilder: (context, index) {
                          Reward? reward = rewardProvider.rewardData[index];
                          int total = reward?.values
                                  ?.where((item) => item.isUsed != true)
                                  .length ??
                              0;
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                  child: AspectRatio(
                                    aspectRatio: 3 / 1,
                                    child: reward?.imageUrl != null
                                        ? Image.network(
                                            reward!.imageUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                color: primaryColor
                                                    .withOpacity(0.1),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.card_giftcard,
                                                    size: 40,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : Container(
                                            color:
                                                primaryColor.withOpacity(0.1),
                                            child: Center(
                                              child: Icon(
                                                Icons.card_giftcard,
                                                size: 40,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),

                                // Info
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              reward?.name ?? "",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Chip(
                                            label: Text(
                                              reward?.type ?? "",
                                              style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                            backgroundColor:
                                                primaryColor.withOpacity(0.1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        reward?.description ?? "",
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.grey.shade300
                                              : Colors.grey.shade700,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.stars_rounded,
                                                size: 16,
                                                color: primaryColor,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${reward?.cost} แต้ม',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 16),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.inventory_2_outlined,
                                                size: 16,
                                                color: isDark
                                                    ? Colors.grey.shade400
                                                    : Colors.grey.shade600,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'เหลือ ${total} ชิ้น',
                                                style: TextStyle(
                                                  color: isDark
                                                      ? Colors.grey.shade400
                                                      : Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),

                                      // Action buttons
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              onPressed: () => {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddEditRewardPage(
                                                              reward: reward,
                                                            )))
                                              },
                                              icon: const Icon(Icons.edit),
                                              label: const Text('แก้ไข'),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: primaryColor,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddRewardItemPage(
                                                                rewardId:
                                                                    reward?.id,
                                                                data: reward
                                                                    ?.values)));
                                              },
                                              icon: const Icon(
                                                  Icons.add_circle_outline),
                                              label: const Text('เพิ่มไอเทม'),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            onPressed: () =>
                                                _showDeleteConfirmation(
                                                    reward!),
                                            icon: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
      ),
    );
  }
}
