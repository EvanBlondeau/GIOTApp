import 'package:flutter/material.dart';
import 'package:veliot/MainPage.dart';
import 'package:veliot/ModifyUser.dart';

import 'journal.dart';
import 'settings.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


Color mColor = Colors.amber;
Color mColorAccent = Colors.amberAccent;

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final _TabPages = [
      Journal(),
      Settings(),
      ModifyUser(),
    ];
    final _tabs = [

      Tab(
        icon: Icon(Icons.assignment),
        text: "History",
      ),
      Tab(
        icon: Icon(Icons.security),
        text: "Security",
      ),
      Tab(
        icon: Icon(Icons.person_outline),
        text: "Profil",
      ),

    ];
    return Builder(
      builder: (ctx) =>
          DefaultTabController(
            length: _tabs.length,
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.amberAccent,
                  title: Text("Véliot APP"),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                        );
                      },
                    ),
                  ],
                  bottom: TabBar(tabs: _tabs),
                ),
                body: TabBarView(children: _TabPages)),
          ),
    );
  }
}