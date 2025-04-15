class TierModel {
  final String name;
  final int minPoints;
  final int maxPoints;
  final String description;

  TierModel({
    required this.name,
    required this.minPoints,
    required this.maxPoints,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'minPoints': minPoints,
      'maxPoints': maxPoints,
      'description': description,
    };
  }

  factory TierModel.fromJson(Map<String, dynamic> json) {
    return TierModel(
      name: json['name'],
      minPoints: json['minPoints'],
      maxPoints: json['maxPoints'],
      description: json['description'],
    );
  }
}
