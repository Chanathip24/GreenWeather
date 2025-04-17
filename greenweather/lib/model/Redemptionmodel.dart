import 'package:greenweather/model/Rewardmodel.dart';
import 'package:greenweather/services/reward_service.dart';

class Redemption {
  final int? id;
  final String? userId;
  final int rewardId;
  final int? rewardValueId;
  final String? rewardValue;
  final DateTime? createdAt;

  Reward? rewardData;

  Redemption({
    this.id,
    this.userId,
    required this.rewardId,
    this.rewardValueId,
    this.createdAt,
    this.rewardValue,
  });

  // ✅ Call this manually after creating the object
  Future<void> init() async {
    rewardData = await _getReward(rewardId);
  }

  factory Redemption.fromJson(Map<String, dynamic> json) {
    return Redemption(
      id: json['id'],
      userId: json['userId'],
      rewardId: json['rewardId'],
      rewardValueId: json['rewardValueId'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      rewardValue:
          json['rewardValue'] != null ? json['rewardValue']['value'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "rewardId": rewardId,
    };
  }
}

Future<Reward> _getReward(int rewardId) async {
  try {
    final RewardService rewardService = RewardService();
    return await rewardService.getRewardbyid(rewardId);
  } catch (e) {
    throw Exception("Error on redemption model can't create Reward object");
  }
}
