import 'package:greenweather/model/Tiermodel.dart';

class Usermodel {
  String? id;
  String? fname;
  String? lname;
  String? email;
  String? password;
  int? points;
  String? role;
  TierModel? tier;

  Usermodel(
      {this.id,
      this.fname,
      this.lname,
      this.email,
      this.password,
      this.points,
      this.role}) {
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
        role: json['role']);
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
      name: 'Raindrop',
      minPoints: 0,
      maxPoints: 99,
      description: 'Every drop counts — you’ve just started!',
    );
  } else if (points < 300) {
    return TierModel(
      name: 'Breeze',
      minPoints: 100,
      maxPoints: 299,
      description: 'Your actions are making a gentle impact.',
    );
  } else if (points < 600) {
    return TierModel(
      name: 'Sunbeam',
      minPoints: 300,
      maxPoints: 599,
      description: 'You’re bringing real light to the planet.',
    );
  } else if (points < 1000) {
    return TierModel(
      name: 'Riverflow',
      minPoints: 600,
      maxPoints: 999,
      description: 'Your efforts are flowing strong and steady.',
    );
  } else {
    return TierModel(
      name: 'Earthkeeper',
      minPoints: 1000,
      maxPoints: 999999,
      description: 'You’re a true guardian of the Earth!',
    );
  }
}
