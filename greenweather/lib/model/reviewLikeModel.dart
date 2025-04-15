class Reviewlikemodel {
  String? userId;
  int reviewId;

  Reviewlikemodel({this.userId, required this.reviewId});

  factory Reviewlikemodel.fromJson(Map<String, dynamic> json) {
    return Reviewlikemodel(userId: json['userId'], reviewId: json['reviewId']);
  }

  Map<String, dynamic> toJson() {
    return {"reviewId": reviewId};
  }
}
