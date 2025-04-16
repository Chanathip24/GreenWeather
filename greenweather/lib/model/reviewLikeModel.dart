class Reviewlikemodel {
  String? userId;
  int reviewId;
  int? rating;

  Reviewlikemodel({this.userId, required this.reviewId, this.rating});

  factory Reviewlikemodel.fromJson(Map<String, dynamic> json) {
    return Reviewlikemodel(userId: json['userId'], reviewId: json['reviewId']);
  }

  Map<String, dynamic> toJson() {
    return {"reviewId": reviewId, 'rating': rating};
  }
}
