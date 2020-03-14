import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sms/sms.dart';
import 'package:veliot/SignUp.dart';

import 'Objects/Contact.dart';
import 'Objects/Geoloc.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new SettingsState();
  }
}

var emergencyCallActivated = false;


class SettingsState extends State<Settings> {
  //TODO: Link contacts to server
  var nameController = TextEditingController();
  var  firstNameController = TextEditingController();
  var surnameController = TextEditingController();
  var phoneController = TextEditingController();


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    firstNameController.dispose();
    surnameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var rawContacts = json.encode([
      {
        "firstName": "Benoît",
        "lastName": "Bernier",
        "surname": "BG",
        "phone": "0617511901",
      },
      {
        "firstName": "Evan",
        "lastName": "Blondeau",
        "surname": "BG2",
        "phone": "0685240262",
      },
      {
        "firstName": "Johann",
        "lastName": "Bourcier",
        "surname": "Boss",
        "phone": "0200000000",
      }
    ]);
    var rawAlarms = json.encode([
      {
        "lat": 14.345678,
        "long": 34.546234,
        "altitude": 45.0,
        "date":
            DateTime.now().subtract(new Duration(days: 17)).toIso8601String(),
      },
      {
        "lat": 45.833641,
        "long": 6.864594,
        "altitude": 4809,
        "date":
            DateTime.now().subtract(new Duration(days: 200)).toIso8601String(),
      }
    ]);

    var contacts = <Contact>[];
    (json.decode(rawContacts))
        .forEach((e) => {contacts.add(Contact.fromJson(e))});

    var alarms = [];
    (json.decode(rawAlarms)).forEach((e) => alarms.add(Geoloc.fromJson(e)));

    return Container(
      padding: EdgeInsets.all(10),
      child: Center(

          child: Column(
        children: <Widget>[

          Text(
            "Emergency calling activation",
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch(
            value: emergencyCallActivated,
            onChanged: (value) {
              setState(() {
                emergencyCallActivated = value;
              });
            },
          ),
          Text(
            "Contacts",
            style: Theme.of(context).textTheme.headline,
          ),
          Expanded(

              child: ListView.builder(

            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final item = contacts[index];
              SmsSender sender = new SmsSender();
              nameController.text=item.getLastName();
              firstNameController.text=item.getFirstName();
              surnameController.text=item.getSurname();
              phoneController.text=item.getPhoneNumber();
              return Dismissible(
                // Each Dismissible must contain a Key. Keys allow Flutter to
                // uniquely identify widgets.
                background: Container(color: Colors.red),
                key: UniqueKey(),
                // Provide a function that tells the app
                // what to do after an item has been swiped away.
                onDismissed: (direction) {
                  // Remove the item from the data source.
                  setState(() {
                    contacts.removeAt(index);
                  });

                  // Show a snackbar. This snackbar could also contain "Undo" actions.
                  Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text("$item dismissed")));
                },
                child: ListTile(
                  leading: Icon(Icons.account_circle),
                  trailing: IconButton(
                      onPressed: () => {
                      showSimpleCustomDialog(context,nameController,firstNameController,surnameController,phoneController),
                      },
                      icon: Icon(Icons.mode_edit)),
                  title: Text(item.getFullName(),
                      style: Theme.of(context).textTheme.title),
                  subtitle: Text(item.getPhoneNumber()),
                  onLongPress: () => emergencyCallActivated
                      ? sender.sendSms(new SmsMessage(item.getPhoneNumber(),
                      'Oh non, je suis tombé !! Je me trouve ici : https://goo.gl/maps/c9LwsKx9V3ZieWus5'))
                      : Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Alertes désactivées"),
                  )),
                ),
              );

            },
          )),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
           child: Text(
              "Alarmes récentes",
              style: Theme.of(context).textTheme.headline,
            ),
          ),


          Expanded(
              child: ListView.builder(
            itemCount: alarms.length,
            itemBuilder: (context, index) {
              final item = alarms[index];
              initializeDateFormatting('fr_FR', null);
              return ListTile(
                  title: Text(
                      new DateFormat.yMMMd('fr_FR')
                          .add_jm()
                          .format(item.getDateTime()),
                      style: Theme.of(context).textTheme.title),
                  subtitle: Text("X : " +
                      item.getLongitude().toString() +
                      ", Y : " +
                      item.getLatitude().toString() +
                      " à " +
                      item.getAltitude().toString() +
                      " mètres d'altitude"));
            },
          )),
        ],
      )),
    );
  }
}


void showSimpleCustomDialog(BuildContext context, name, pren, sur, phone) {

  Dialog simpleDialog = Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),

    child: Container(

      height: 400.0,
      width: 300.0,
      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: Text(
              "Modifier",

              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: TextField(
                decoration:
                InputDecoration(hintText: 'Nom'),
                controller: name,
              ),
            ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: TextField(
              decoration:
              InputDecoration(hintText: 'Prénom'),
              controller: pren,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: TextField(
              decoration:
              InputDecoration(hintText: 'Surnom'),
              controller: sur,
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
           child: TextField(
                decoration:
                InputDecoration(hintText: 'Téléphone'),
                controller: phone,
                keyboardType:
                TextInputType.numberWithOptions())
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
                    'Retour',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  color: Colors.amberAccent,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)
                  ),
                  child: Text(
                    'Enregistrer',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
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

