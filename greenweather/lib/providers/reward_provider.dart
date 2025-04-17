import 'package:flutter/material.dart';
import 'package:greenweather/model/Redemptionmodel.dart';
import 'package:greenweather/model/Rewardmodel.dart';
import 'package:greenweather/services/api_service.dart';
import 'package:greenweather/services/reward_service.dart';

class RewardProvider extends ChangeNotifier {
  List<Reward?> _rewardData = [];

  List<Redemption> _userRedeem = [];
  bool _isLoading = false;
  String? _error;

  // Getter methods
  List<Reward?> get rewardData => _rewardData;
  List<Redemption> get userRedeem => _userRedeem;
  bool get isLoading => _isLoading;
  String? get error => _error;

  //api service
  final Apiservice _apiservice = Apiservice(); //ส่ง access token ไปด้วย
  final RewardService _rewardService = RewardService();

  //method
  Future<void> getRewards() async {
    _isLoading = true;
    _rewardData = [];
    _error = null;
    notifyListeners();

    try {
      final rewards = await _rewardService.getRewards();
      _rewardData = rewards;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  //create
  Future<void> createReward(Reward reward) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final Reward result = await _rewardService.createReward(reward);
      _rewardData.add(result);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  //update Reward
  Future<void> updateReward(Reward reward) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final Reward result = await _rewardService.updateReward(reward);
      _rewardData = _rewardData.map((item) {
        return item!.id == result.id ? result : item;
      }).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  //create RewardItem
  Future<void> createRewardItem(RewardItem item) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final RewardItem response = await _rewardService.createRewardItem(item);
      _rewardData = _rewardData.map((reward) {
        if (reward!.id == response.rewardId) {
          return Reward(
            id: reward.id,
            name: reward.name,
            description: reward.description,
            cost: reward.cost,
            type: reward.type,
            imageUrl: reward.imageUrl,
            values: [...?reward.values, response],
          );
        } else {
          return reward;
        }
      }).toList();
      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  //redeem code
  Future<void> redeem(Redemption redeem) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final Redemption response = await _apiservice.redeemReward(redeem);
      _isLoading = false;
      if (!_userRedeem.any((r) => r.id == response.id)) {
        _userRedeem.add(response);
      }
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> getredeemdata() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final List<Redemption> data = await _apiservice.getAllredeem();
      _isLoading = false;
      _error = null;
      _userRedeem = data;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
}
