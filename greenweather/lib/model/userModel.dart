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
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'fname': fname ?? null,
      'lname': lname ?? null,
    };
  }
}
