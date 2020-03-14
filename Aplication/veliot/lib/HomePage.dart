
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:veliot/Bernier/MyHomePage.dart';
import 'package:veliot/MainPage.dart';
import 'package:veliot/podo/json_podo.dart';

import 'SignUp.dart';
import 'custom_route.dart';
import 'dashboard.dart';


class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class Argument {
  final String userN;
  final String passW;

  Argument(this.userN, this.passW);
}

class HomeState extends State<Home> {

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2225);
  bool loginPath =true;

  Future<String> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      Response response;
      Dio dio = new Dio();
      String myJSON ='{"username":"${data.name}", "password":"${data.password}"}';
      //String myJSON ='{"username": "dd@gmail.com", "password": "22"}';
      var json2 = jsonDecode(myJSON);

      try {
        response = await dio.post("http://192.168.43.68:3000/api/authentication", data:json2);
        
        print(jsonDecode(response.statusCode.toString()));
      } catch (e) {
        print(e);
        return "server not available";
      }
      
      int rep = response.statusCode;



      if(rep == 200){
        Authentification auth = new Authentification.fromJson(response.data);
        print(auth.JWT);

        // Create storage
        final storage = new FlutterSecureStorage();

        // Write value
        await storage.write(key: 'jwt', value: auth.JWT);

        return null;
      }else if( response.statusCode == 400){
        return "Wrong password or email!";
      }else{
        return "a error occur! ";
      }
    });
  }

  String mail;
  String pass;

  Future<String> _signUp(LoginData data) {
    return Future.delayed(loginTime).then((_) {

    /*  if (data.name != "@.com") {
        return 'Username not exists';
      }
      if (data.password != "0") {
        return 'Password does not match';
      }*/
      loginPath =false; //on veut une autre route pour qqun qui s'inscrit
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (name != "@.com") {
        return 'Username not exists';
      }
      return null;
    });
  }

  Future<void> _passData(String name, String ps) {
    mail= name;
    pass =ps;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(20.0),
    );

    return FlutterLogin(
      title: "",
      logo: 'assets/velo.png',
      //logoTag: Constants.logoTag,
      //titleTag: Constants.titleTag,

      emailValidator: (value) {
        /*if (!value.contains('@') || !value.endsWith('.com')) {
          return "Email must contain '@' and end with '.com'";
        }*/
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return 'Password is empty';
        }
        return null;
      },
      onLogin: (loginData) {
        print('Login info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _loginUser(loginData);
      },

      onSignup: (loginData) {
        _passData(loginData.name,loginData.password);
        print('Signup info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _signUp(loginData);
      },
      onRecoverPassword: (name) {
        print('Recover password info');
        print('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      onSubmitAnimationCompleted: () {
        if(loginPath){
          Navigator.of(context).pushReplacement(FadePageRoute(
            builder: (context) => MyHomePage(),
          ));
        }else{
          Navigator.pushNamed(
              context,
              SignUp.routeName,
              arguments: Argument(
              mail,
              pass,
          ));
        }
      },
      showDebugButtons: false,
    );
  }
}



