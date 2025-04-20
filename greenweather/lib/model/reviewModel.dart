class Reviewmodel {
  final int? id;
  final String userId;
  final String location;
  final String? createdAt;
  final int aqi;
  int? rating;
  final int? dislike;
  final String detail;
  final String? ownerName;
  final double? cost;
  final String? main;
  bool isLike = false;

  Reviewmodel(
      {this.id,
      required this.aqi,
      required this.userId,
      required this.location,
      this.createdAt,
      this.rating,
      this.dislike,
      required this.detail,
      this.ownerName,
      this.cost,
      this.main});

  factory Reviewmodel.fromJson(Map<String, dynamic> json) {
    return Reviewmodel(
        id: json['id'] as int,
        userId: json['userId'] as String,
        location: json['location'] as String,
        aqi: json['aqi'] as int,
        createdAt: json['createdAt'] as String,
        rating: json['rating'] as int,
        dislike: json['dislike'] as int,
        detail: json['detail'] as String,
        ownerName: json['user']['fname'] as String,
        main: json['main']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'location': location,
      'aqi': aqi,
      'createdAt': createdAt,
      'rating': rating,
      'dislike': dislike,
      'detail': detail,
      'ownerName': ownerName,
      'main': main
    };
  }
}
