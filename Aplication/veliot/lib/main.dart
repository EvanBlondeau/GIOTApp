import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:veliot/MainPage.dart';
import 'package:veliot/SignUp.dart';
import 'package:veliot/ble.dart';
import 'package:veliot/discovery.dart';
import 'package:veliot/transition_route_observer.dart';

import 'HomePage.dart';
import 'dashboard.dart';



void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor:
      SystemUiOverlayStyle.dark.systemNavigationBarColor,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Véliot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        accentColor: Colors.amber,
        cursorColor: Colors.black,
        // fontFamily: 'SourceSansPro',
        textTheme: TextTheme(
          headline3: TextStyle(
            fontFamily: 'Sarpanch',
            fontSize: 55.0,
            //  fontWeight: FontWeight.w400,
            color: Colors.blueGrey,
          ),
          button: TextStyle(
            // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
            fontFamily: 'OpenSans',
          ),
          caption: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color:  Colors.blueGrey,
          ),
          headline1: TextStyle(fontFamily: 'Quicksand'),
          headline2: TextStyle(fontFamily: 'Quicksand'),
          headline4: TextStyle(fontFamily: 'Quicksand'),
          headline5: TextStyle(fontFamily: 'NotoSans'),
          headline6: TextStyle(fontFamily: 'NotoSans'),
          subtitle1: TextStyle(fontFamily: 'NotoSans'),
          bodyText1: TextStyle(fontFamily: 'NotoSans'),
          bodyText2: TextStyle(fontFamily: 'NotoSans'),
          subtitle2: TextStyle(fontFamily: 'NotoSans'),
          overline: TextStyle(fontFamily: 'NotoSans'),
        ),
      ),
      initialRoute: '/',
      navigatorObservers: [TransitionRouteObserver()],
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => Home(),
        '/ble': (context) => Ble(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/discover': (context) => MainPage(),
        '/dash': (context) => DashboardScreen(),
        SignUp.routeName: (context) => SignUp(),
      },
    );
  }
}

