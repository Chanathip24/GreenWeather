class RewardItem {
  final int? id;
  final String value;
  final bool isUsed;
  final int rewardId;
  final DateTime? createdAt;

  RewardItem(
      {this.id,
      required this.value,
      required this.isUsed,
      required this.rewardId,
      this.createdAt});

  factory RewardItem.fromJson(Map<String, dynamic> json) {
    return RewardItem(
        id: json['id'],
        value: json['value'],
        isUsed: json['isUsed'],
        rewardId: json['rewardId'],
        createdAt: DateTime.parse(json['createdAt']));
  }

  Map<String, dynamic> toJson() {
    return {"rewardId": rewardId, "value": value, "isUsed": isUsed};
  }
}

class Reward {
  final int id;
  final String name;
  final String? description;
  final int cost;
  final String type;
  final String? imageUrl;
  final List<RewardItem>? values;

  Reward(
      {required this.id,
      required this.name,
      this.description,
      this.imageUrl,
      required this.cost,
      required this.type,
      this.values});

  factory Reward.fromJson(Map<String, dynamic> json) {
    final List? data = json['values'];
    return Reward(
        id: json['id'],
        name: json['name'],
        description: json['description'] ?? '',
        imageUrl: json['imgUrl'] ??
            'https://t3.ftcdn.net/jpg/02/48/42/64/360_F_248426448_NVKLywWqArG2ADUxDq6QprtIzsF82dMF.jpg',
        cost: json['cost'],
        type: json['type'],
        values: data?.map((item) => RewardItem.fromJson(item)).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "cost": cost,
      "type": type,
      "imgUrl": imageUrl,
    };
  }
}
