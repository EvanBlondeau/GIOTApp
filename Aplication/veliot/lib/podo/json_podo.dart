import 'dart:ffi';

class User {
  final String firstName;
  final String lastName;
  final String sex;
 final  String weight;
 final  String birthDate;
  final String height;
  final List<Contacts> contacts;

  User(
      {this.firstName,
        this.lastName,
        this.sex,
        this.weight,
        this.birthDate,
        this.height,
        this.contacts});

  factory User.fromJson(Map<String, dynamic> json) {


    var list = json["contacts"] as List;
    print(list.runtimeType);
    List<Contacts> contactList = list.map((i) => Contacts.fromJson(i)).toList();
    return User(

        firstName: json["firstName"],
        lastName: json["lastName"],
        sex: json["sex"],
        weight: json["weight"],
        birthDate: json["birthDate"],
        height: json["height"],
        contacts: contactList
    );
  }
}


class Contacts {
  String firstName;
  String lastName;
  String nickname;
  String phone;

  Contacts(
      {this.firstName,
        this.lastName,
        this.nickname,
        this.phone,
      });

  factory Contacts.fromJson(Map<String, dynamic> json) {
    return Contacts(
        firstName: json["firstName"],
        lastName: json["lastName"],
        nickname: json["nickname"],
        phone: json["phone"],
    );}
}

//help : https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51

//PARSING https://medium.com/flutterdevs/parsing-complex-json-in-flutter-b7f991611d3e

//token json
class Authentification {
  String JWT;
  String username;

  Authentification(
      {this.JWT,
      this.username});

  factory Authentification.fromJson(Map<String, dynamic> json) {
    return Authentification(
          username: json["usernama"],
        JWT: json["JWT"],

    );

  }
}