class Usermodel {
  String? id;
  String? fname;
  String? lname;
  String? email;
  String? password;
  int? points;

  Usermodel({
    this.id,
    this.fname,
    this.lname,
    this.email,
    this.password,
    this.points,
  });

  factory Usermodel.fromJson(Map<String, dynamic> json) {
    return Usermodel(
      id: json['id'],
      fname: json['fname'],
      lname: json['lname'],
      email: json['email'],
      points: json['points'],
    );
  }
  //tojson
  static Map<String, dynamic> toJson(Usermodel user) {
    return {
      'email': user.email,
      'password': user.password,
      'fname': user.fname ?? null,
      'lname': user.lname ?? null,
    };
  }
}
