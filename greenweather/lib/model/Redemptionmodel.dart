import 'package:greenweather/model/Rewardmodel.dart';

class Redemption {
  final int id;
  final String? userId;
  final int rewardId;
  final int? rewardValueId;
  final String? rewardValue;
  final String? value;
  final DateTime? createdAt;
  final Reward? reward;
  final bool? isUsed;

  Redemption(
      {required this.id,
      this.userId,
      required this.rewardId,
      this.rewardValueId,
      this.rewardValue,
      this.createdAt,
      this.reward,
      this.value,
      this.isUsed});

  factory Redemption.fromJson(Map<String, dynamic> json) {
    return Redemption(
      id: json['id'],
      userId: json['userId'],
      rewardId: json['rewardId'],
      rewardValueId: json['rewardValueId'],
      rewardValue: json['rewardValue']?['value'],
      createdAt: json['createdAt'] ? DateTime.parse(json['createdAt']) : null,
    );
  }
}
