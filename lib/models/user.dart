
import 'package:rte_app/models/article.dart';

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? middleName;
  String? email;
  String? rememberToken;
  String? password;
  String? confirmPassword;
  String? token;
  List<Article>? articles;
  String? profilePhoto;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.middleName,
    this.email,
    this.rememberToken,
    this.password,
    this.confirmPassword,
    this.token,
    this.profilePhoto,
    this.articles = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'middle_name': middleName ?? "",
      'email_address': email,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    var model = User();
    model.id = map['id'];
    model.firstName = map['first_name'];
    model.lastName = map['last_name'];
    model.middleName = map['middle_name'] ?? "";
    model.email = map['email_address'];
    model.profilePhoto = map['profile_picture'];
    model.token = map['token'];
    return model;
  }

}