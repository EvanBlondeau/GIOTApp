import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
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


class SignUp extends StatefulWidget {
  static const routeName = '/SignUp';
  @override
  _Sign createState() => _Sign();

}

class _Sign extends State<SignUp>
    with SingleTickerProviderStateMixin, TransitionRouteAware {

  Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed('/')
        // we dont want to pop the screen, just replace it completely
        .then((_) => false);
  }

  changeText(DateTime d) {
    setState(() {
      dateBirth = d;
    });
  }



  @override
  Widget build(BuildContext context) {

    final Argument args = ModalRoute.of(context).settings.arguments;
    user  = args.userN;
    pass = args.passW;

    try{
      print(user + pass);
    }catch(e){
      print("errror");
    }


    return Scaffold(

      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(5),
                child: Text(
                  'Sign Up to Veliot',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
              height: 60.0,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'First Name',
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
                  labelText: 'Last Name',
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),

                  child: Row(

                      children: [
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
                  borderSide:BorderSide(color:Colors.amber),
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
                                    _valueHeight = newValue.round() ;
                                  });
                                },
                                semanticFormatterCallback: (double newValue) {
                                  return '${newValue.round()} dollars';
                                })),
                      ]),
                )),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text(
                  'Emmergency  contact  ',
                  style: TextStyle(fontSize: 20,color: Colors.black,),
                )),
            Row(children: <Widget>[
              new Flexible(
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextField(
                    controller: firstNameContact,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                    ),
                  ),
                ),
              ),
              new Flexible(
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextField(
                    controller: lastNameContact,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                    ),
                  ),
                ),
              ),
            ]),
            Row(children: <Widget>[
              new Flexible(
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: TextField(
                    controller: phoneNumberContact,
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                    ),
                  ),
                ),
              ),
              new Flexible(
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: TextField(
                    controller: nickNameContact,
                    decoration: InputDecoration(
                      labelText: 'nickname',
                    ),
                  ),
                ),
              ),
            ]),

            Row(children: <Widget>[

              Expanded(
                child:Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.black,
                      color: Colors.amberAccent,
                      child: Text('Back'),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)
                      ),
                      onPressed: () {

                        //après l'envoie des donées et validation => home
                        _goToLogin(context);
                      },
                    ))),

                Expanded(
                  child:Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(

                      textColor: Colors.black,
                      color: Colors.amberAccent,
                      child: Text('Sign Up'),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)
                      ),
                      onPressed: () async {

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
                        print(dropdownValue[0]);
                        List<String> strDate = dateBirth.toString().split(' ');

                        //5e42f7e2ed42bf003e00db6d
                      //  String myJSON = '{"username": "e@gmail.com","password": "van","firstName": "evan","lastName": "dd","sex": "H","weight": 75.6,"birthDate": "2019-12-24","contacts": [{"firstName": "Marco","lastName": "Polo","phone": 3360000000,"surname": "Dad"},{"firstName": "Marco","lastName": "Polo","phone": 3360000000,"surname": "Dad"}],"height": 1.82}';
                        String myJSON = '{"username": "${user}","password": "${pass}","firstName": "'
                            '${firstNameController.text}","lastName": "'
                            '${lastNameController.text}","sex": "'
                            '${dropdownValue[0]}","weight": ${_valueWeight},"birthDate": "'
                            '${strDate[0]}","contacts": [{"firstName": "${firstNameContact.text}","lastName": "${lastNameContact.text}","phone": '
                            '"${phoneNumberContact.text}","surname": "${nickNameContact.text}"},{"firstName": "Marco","lastName": "Polo","phone": 3360000000,"surname": "Dad"}],"height":'
                            ' ${_valueHeight}}';

                        var json = jsonDecode(myJSON);

                         Response response;
                         Dio dio = new Dio();
                         try{
                           response = await dio.post("http://192.168.43.68:3000/api/user", data: json);
                         }catch(e){
                           print(e);
                           showSimpleCustomDialog(context);
                         }


                         int f = response.statusCode;

                         print(response.statusCode);

                        if(f == 201){
                           _goToLogin(context);
                         }

                        //après l'envoie des donées et validation => home
                        //_goToLogin(context);
                      },
                    ))),
              ])


             ])

      ),
    );
  }
}



void showSimpleCustomDialog(BuildContext context) {
  Dialog simpleDialog = Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: 250.0,
      width: 300.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Text(
               "Your email is already used",
                style: TextStyle(color: Colors.red),
            ),
          ),
             Container(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
              child: TextField(
                controller: emailText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: user.toString(),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)
                  ),
                  color: Colors.amberAccent,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Back',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  color: Colors.amberAccent,
                  onPressed: () async {

                    List<String> strDate = dateBirth.toString().split(' ');

                    String myJSON = '{"username": "${emailText.text}","password": "${pass}","firstName": "'
                        '${firstNameController.text}","lastName": "'
                        '${lastNameController.text}","sex": "'
                        '${dropdownValue[0]}","weight": ${_valueWeight},"birthDate": "'
                        '${strDate[0]}","contacts": [{"firstName": "${firstNameContact.text}","lastName": "${lastNameContact.text}","phone": '
                        '"${phoneNumberContact.text}","surname": "${nickNameContact.text}"},{"firstName": "Marco","lastName": "Polo","phone": 3360000000,"surname": "Dad"}],"height":'
                        ' ${_valueHeight}}';

                    var json = jsonDecode(myJSON);

                    Response response;
                    Dio dio = new Dio();
                    try{
                      response = await dio.post("http://192.168.43.68:3000/api/user", data: json);
                    }catch(e){
                      print(e);

                    }


                    if(response.statusCode == 201){
                      Navigator.of(context)
                          .pushReplacementNamed('/')
                      // we dont want to pop the screen, just replace it completely
                          .then((_) => false);
                    }else{
                      Navigator.of(context).pop();
                    }




                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
  showDialog(
      context: context, builder: (BuildContext context) => simpleDialog);
}
