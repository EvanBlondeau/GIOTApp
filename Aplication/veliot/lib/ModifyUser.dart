import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:veliot/podo/json_podo.dart';
import 'HomePage.dart';
import 'transition_route_observer.dart';

DateTime dateBirth;

TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController firstNameContact = TextEditingController();
TextEditingController lastNameContact = TextEditingController();
TextEditingController nickNameContact = TextEditingController();
TextEditingController phoneNumberContact = TextEditingController();
TextEditingController emailText = TextEditingController();

String dropdownValue = 'Woman';
int _valueWeight = 5;
int _valueHeight = 100;

String user;
String pass;

class ModifyUser extends StatefulWidget {
  static const routeName = '/ModifyData';

  @override
  _ModifyUser createState() => _ModifyUser();

}

User user_request;

Future<void> request() async {
  var dio = Dio();

  final storage = new FlutterSecureStorage();
  String value = await storage.read(key: 'jwt');
  print(value);

  dio.interceptors.add(InterceptorsWrapper(
      onRequest:(RequestOptions options) async {
        options.headers["Authorization"] = value;
        return options; //continue
        // If you want to resolve the request with some custom data，
        // you can return a `Response` object or return `dio.resolve(data)`.
        // If you want to reject the request with a error message,
        // you can return a `DioError` object or return `dio.reject(errMsg)`
      },
      onResponse:(Response response) async {
        // Do something with response data
        return response; // continue
      },
      onError: (DioError e) async {
        // Do something with response error
        return  e;//continue
      }
  ));



  Response response = await dio.get("http://192.168.43.68:3000/api/user/me");
  print(response.statusCode);
  print(response.data);

  user_request = new User.fromJson(response.data);
  print(user_request.firstName);
  firstNameController.text=user_request.firstName;
  lastNameController.text=user_request.lastName;
  _valueHeight = int.parse(user_request.height);
  _valueWeight = int.parse(user_request.weight);

  if(user_request.sex=="M"){
    dropdownValue = 'Man';
  }


  return null;
}

class _ModifyUser extends State<ModifyUser>
    with SingleTickerProviderStateMixin, TransitionRouteAware {


  changeText(DateTime d) {
    setState(() {
      dateBirth = d;
    });
  }




  @override
  Widget build(BuildContext context) {
    request();
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  'Your personal data',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                )),
            Container(
              height: 60.0,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'first name',
                  hoverColor: Colors.amberAccent,
                ),
              ),
            ),
            Container(
              height: 60.0,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Last name',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(children: [
                Text(
                  "Gender :",
                  style: TextStyle(color: Colors.black),
                ),
                new Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      focusColor: Colors.amber,
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>['Woman', 'Man', 'Other']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ]),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              height: 60.0,
              child: OutlineButton(
                  borderSide: BorderSide(color: Colors.amber),
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(1900, 1, 1),
                        maxTime: DateTime(2020, 1, 11), onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      changeText(date);
                      print('confirm $date');
                    }, currentTime: DateTime.now(), locale: LocaleType.fr);
                  },
                  child: Text(
                    dateBirth != null
                        ? dateBirth.toString()
                        : "Select your birth date",
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.left,
                  )),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Weight (kg) :",
                          style: TextStyle(color: Colors.black),
                        ),
                        new Expanded(
                            child: Slider(
                                value: _valueWeight.toDouble(),
                                min: 5,
                                max: 150,
                                divisions: 150,
                                activeColor: Colors.amberAccent,
                                inactiveColor: Colors.black12,
                                label: _valueWeight.toString(),
                                onChanged: (double newValue) {
                                  setState(() {
                                    _valueWeight = newValue.round();
                                  });
                                },
                                semanticFormatterCallback: (double newValue) {
                                  return '${newValue.round()} dollars';
                                })),
                      ]),
                )),
            Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Height (cm) :",
                          style: TextStyle(color: Colors.black),
                        ),
                        new Expanded(
                            child: Slider(
                                value: _valueHeight.toDouble(),
                                min: 100,
                                max: 250,
                                divisions: 150,
                                activeColor: Colors.amberAccent,
                                inactiveColor: Colors.black12,
                                label: _valueHeight.toString(),
                                onChanged: (double newValue) {
                                  setState(() {
                                    _valueHeight = newValue.round();
                                  });
                                },
                                semanticFormatterCallback: (double newValue) {
                                  return '${newValue.round()} dollars';
                                })),
                      ]),
                )),
            Row(children: <Widget>[
              Expanded(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: RaisedButton(
                        textColor: Colors.black,
                        color: Colors.amberAccent,
                        child: Text('Enregistrer'),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        onPressed: () async {
                          print(dropdownValue[0]);
                          List<String> strDate =
                              dateBirth.toString().split(' ');

                          //  String myJSON = '{"username": "e@gmail.com","password": "van","firstName": "evan","lastName": "dd","sex": "H","weight": 75.6,"birthDate": "2019-12-24","contacts": [{"firstName": "Marco","lastName": "Polo","phone": 3360000000,"surname": "Dad"},{"firstName": "Marco","lastName": "Polo","phone": 3360000000,"surname": "Dad"}],"height": 1.82}';
                          String myJSON =
                              '{"username": "${user}","password": "${pass}","firstName": "'
                              '${firstNameController.text}","lastName": "'
                              '${lastNameController.text}","sex": "'
                              '${dropdownValue[0]}","weight": ${_valueWeight},"birthDate": "'
                              '${strDate[0]}","contacts": [{"firstName": "${firstNameContact.text}","lastName": "${lastNameContact.text}","phone": '
                              '"${phoneNumberContact.text}","surname": "${nickNameContact.text}"},{"firstName": "Marco","lastName": "Polo","phone": 3360000000,"surname": "Dad"}],"height":'
                              ' ${_valueHeight}}';

                          var json = jsonDecode(myJSON);



                          var dio = Dio();

                          final storage = new FlutterSecureStorage();
                          String value = await storage.read(key: 'jwt');
                          print(value);

                          dio.interceptors.add(InterceptorsWrapper(
                              onRequest:(RequestOptions options) async {
                                options.headers["Authorization"] = value;
                                return options; //continue
                                // If you want to resolve the request with some custom data，
                                // you can return a `Response` object or return `dio.resolve(data)`.
                                // If you want to reject the request with a error message,
                                // you can return a `DioError` object or return `dio.reject(errMsg)`
                              },
                              onResponse:(Response response) async {
                                // Do something with response data
                                return response; // continue
                              },
                              onError: (DioError e) async {
                                // Do something with response error
                                return  e;//continue
                              }
                          ));

                          Response response = await dio.put("http://192.168.43.68:3000/api/user/me",data:json);
                          print(response.data.toString());

                          int f = response.statusCode;

                          print(response.statusCode);

                          if (f == 204) {
                            Toast.show("User has been modify", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

                          }else{
                            Toast.show("An error occur", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                          }

                          //après l'envoie des donées et validation => home
                          //_goToLogin(context);
                        },
                      ))),
            ])
          ])),
    );
  }
}

                        /*print(firstNameController.text);
                        print(lastNameController.text);
                        print(firstNameContact.text);
                        print(lastNameContact.text);
                        print(nickNameContact.text);
                        print(phoneNumberContact.text);
                        print(dateBirth.toString());
                        print(_valueWeight);
                        print(_valueHeight);
                        print(dropdownValue);*/
