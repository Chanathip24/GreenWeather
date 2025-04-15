class Transactionmodel {
  final int id;
  final String userId;
  final int points;
  final String type;
  final String reason;
  final String createdAt;
  
  Transactionmodel({
    required this.id,
    required this.userId,
    required this.points,
    required this.type,
    required this.reason,
    required this.createdAt,
  });

  factory Transactionmodel.fromJson(Map<String, dynamic> json) {
    return Transactionmodel(
      id: json['id'] as int,
      userId: json['userId'] as String,
      points: json['points'] as int,
      type: json['type'] as String,
      reason: json['reason'] as String,
      createdAt: json['createdAt'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'points': points,
      'type': type,
      'reason': reason,
      'createdAt': createdAt,
    };
  }
}