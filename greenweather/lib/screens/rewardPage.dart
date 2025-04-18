import 'package:flutter/material.dart';
import 'package:greenweather/model/Redemptionmodel.dart';
import 'dart:async';

import 'package:greenweather/model/Rewardmodel.dart';

import 'package:greenweather/providers/authentication_provider.dart';

import 'package:greenweather/providers/reward_provider.dart';
import 'package:greenweather/screens/rewardHistoryPage.dart';
import 'package:provider/provider.dart';

class RewardsPage extends StatefulWidget {
  int points;
  RewardsPage({super.key, required this.points});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  int _selectedCategoryIndex = 0;
  //categories
  final List<String> _categories = ['All', 'Food', 'Vouchers', 'Digital'];
  List<Reward?> _allRewards = [];

  List<Reward?> _filteredRewards = [];

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
    _allRewards = rewardProvider.rewardData;
    if (_selectedCategoryIndex == 0) {
      _filteredRewards = List.from(_allRewards);
    }
  }

  void _filterRewards() {
    if (_selectedCategoryIndex == 0) {
      _filteredRewards = List.from(_allRewards);
    } else {
      final category = _categories[_selectedCategoryIndex].toUpperCase();
      _filteredRewards = _allRewards
          .where((item) =>
              item!.type.toUpperCase().contains(category) ||
              (category == 'VOUCHERS' &&
                  item.type.toUpperCase().contains('VOUCHER')))
          .toList();
    }
  }

  Future<void> _redeemReward(Reward reward) async {
    if (widget.points < reward.cost) {
      _showInsufficientPointsDialog(reward);
      return;
    }

    // Check if there are rewards left
    final int totalAvaliable =
        reward.values?.where((item) => item.isUsed != true).length ?? -1;

    if (totalAvaliable <= 0) {
      _showNoRewardsLeftDialog();
      return;
    }

    // Show confirmation dialog
    bool confirmed = await _showConfirmationDialog(reward);
    if (!confirmed) {
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    //provider
    final RewardProvider rewardProvider =
        Provider.of<RewardProvider>(context, listen: false);
    final AuthenticationProvider authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    //redeem
    await rewardProvider
        .redeem(Redemption(rewardId: reward.id)); // Simulate API call

    authenticationProvider.deductPoints(reward.cost);
    widget.points = widget.points - reward.cost;

    Navigator.pop(context); // Close loading dialog

    //if failed
    if (rewardProvider.error != null) {
      _showFailDialog(reward);
      return;
    }
    //if success
    _showSuccessDialog(reward);
  }

  Future<bool> _showConfirmationDialog(Reward reward) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Redeem ${reward.name}?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Use ${reward.cost} points to redeem this reward?'),
                const SizedBox(height: 12),
                Text(
                  'Points remaining after redemption: ${widget.points - reward.cost}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Confirm'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showSuccessDialog(Reward reward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Redemption Successful!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            Text('You have successfully redeemed ${reward.name}'),
            const SizedBox(height: 12),
            const Text(
              'Check your "My Rewards" section to view your reward details',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyRewardsPage()));
            },
            child: const Text('View My Rewards'),
          ),
        ],
      ),
    );
  }

  void _showFailDialog(Reward reward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Redemption Failed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cancel, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            Text('You failed to  ${reward.name}'),
            const SizedBox(height: 12),
            const Text(
              'Please try again later',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyRewardsPage()));
            },
            child: const Text('View My Rewards'),
          ),
        ],
      ),
    );
  }

  void _showInsufficientPointsDialog(Reward reward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Insufficient Points'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You need ${reward.cost} points to redeem this reward.'),
            const SizedBox(height: 8),
            Text('Your current points: ${widget.points}'),
            const SizedBox(height: 8),
            Text('Points needed: ${reward.cost - widget.points}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showNoRewardsLeftDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Rewards Left'),
        content: const Text('Sorry, this reward is out of stock.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rewardProvider = Provider.of<RewardProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Rewards Center',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.card_giftcard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyRewardsPage()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          try {
            _loadRewards();
          } catch (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error refreshing rewards: $error')),
            );
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              _buildPointsDisplay(),
              _buildCategorySelector(),
              if (rewardProvider.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (rewardProvider.error != null)
                Expanded(
                  child: Center(child: Text(rewardProvider.error!)),
                )
              else if (_filteredRewards.isEmpty)
                const Expanded(
                  child:
                      Center(child: Text('No rewards found in this category')),
                )
              else
                Expanded(
                  child: _buildRewardsGrid(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointsDisplay() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          const Text(
            'Your Points:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${widget.points} points',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 50,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = index;
                  _filterRewards();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  color: _selectedCategoryIndex == index
                      ? Colors.green
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    _categories[index],
                    style: TextStyle(
                      color: _selectedCategoryIndex == index
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRewardsGrid() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _filteredRewards.length,
        itemBuilder: (context, index) {
          final reward = _filteredRewards[index];
          return _buildRewardCard(reward!);
        },
      ),
    );
  }

  Widget _buildRewardCard(Reward reward) {
    final bool canAfford = widget.points >= reward.cost;
    final int totalAvaliable =
        reward.values?.where((item) => item.isUsed != true).length ?? -1;
    final bool isAvailable = totalAvaliable > 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  reward.imageUrl ?? "",
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 100,
                      color: Colors.grey[300],
                      child:
                          const Center(child: Icon(Icons.image_not_supported)),
                    );
                  },
                ),
              ),
              // Out of stock overlay
              if (!isAvailable)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'OUT OF STOCK',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              // Limited stock indicator
              if (isAvailable && totalAvaliable < 10)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Only ${totalAvaliable} left',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Reward details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${reward.cost} points',
                  style: TextStyle(
                    color: canAfford ? Colors.green : Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (canAfford && isAvailable)
                        ? () => _redeemReward(reward)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      disabledBackgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isAvailable
                          ? (canAfford ? 'Redeem' : 'Not enough points')
                          : 'Out of stock',
                      style: TextStyle(
                        color: (canAfford && isAvailable)
                            ? Colors.white
                            : Colors.grey[700],
                        fontSize: 12,
                      ),
                    ),
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
