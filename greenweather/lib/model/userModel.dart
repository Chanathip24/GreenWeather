import 'package:greenweather/model/Tiermodel.dart';

class Usermodel {
  String? id;
  String? fname;
  String? lname;
  String? email;
  String? password;
  int? points;
  TierModel? tier;

  Usermodel({
    this.id,
    this.fname,
    this.lname,
    this.email,
    this.password,
    this.points,
  }) {
    assignTier();
  }

  void assignTier() {
    int userPoints = points ?? 0;
    tier = _getTierFromPoints(userPoints);
  }

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

TierModel _getTierFromPoints(int points) {
  if (points < 100) {
    return TierModel(
      name: 'Seedling',
      minPoints: 0,
      maxPoints: 99,
      description: 'Just getting started on your eco journey.',
    );
  } else if (points < 300) {
    return TierModel(
      name: 'Planter',
      minPoints: 100,
      maxPoints: 299,
      description: 'Helping the planet by being consistent.',
    );
  } else if (points < 600) {
    return TierModel(
      name: 'Grower',
      minPoints: 300,
      maxPoints: 599,
      description: 'Actively making a difference.',
    );
  } else if (points < 1000) {
    return TierModel(
      name: 'Guardian',
      minPoints: 600,
      maxPoints: 999,
      description: 'Protecting the Earth with your actions.',
    );
  } else {
    return TierModel(
      name: 'Eco Hero',
      minPoints: 1000,
      maxPoints: 999999,
      description: 'You are a true hero for the environment!',
    );
  }
}
