import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:convert';

import 'package:intl/date_symbol_data_local.dart';
import 'package:veliot/BackgroundCollectingTask.dart';

import '../SelectBondedDevicePage.dart';
import 'CustomWidgets/HistoryTile.dart';
import 'Objects/Event.dart';

class Journal extends StatefulWidget {
  Journal({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => JournalState();
}

class JournalState extends State<Journal> {
    @override
    Widget build(BuildContext context) {
      List<String> d =['assets/1.png','assets/2.png','assets/4.png','assets/3.png'];
      var rawEvents = json.encode([
      {
        'titre': 'Training session',
        "event_type": "training",
        "description": "A little bike training with Peter.",
        "end":
            DateTime.now().subtract(new Duration(days: 17)).toIso8601String(),
        "begin": DateTime.now()
            .subtract(new Duration(days: 17))
            .subtract(new Duration(minutes: 145))
            .toIso8601String()
      },
      {
        'titre': 'Cheat meal',
        "event_type": "transport",
        "description": "Getting burgers with my buddies.",
        "end": DateTime.now().subtract(new Duration(days: 2)).toIso8601String(),
        "begin": DateTime.now()
            .subtract(new Duration(days: 2))
            .subtract(new Duration(minutes: 12))
            .toIso8601String()
      },
      {
        'titre': 'Euh...Mmmh...',
        "event_type": "transport",
        "description": "Going to a brothel.",
        "end": DateTime.now().subtract(new Duration(days: 1)).toIso8601String(),
        "begin": DateTime.now()
            .subtract(new Duration(days: 1))
            .subtract(new Duration(minutes: 45))
            .toIso8601String()
      },
      {
        'titre': 'Road Trip 2019',
        "event_type": "roadtrip",
        "description": "From Mexico to Texas",
        "end":
            DateTime.now().subtract(new Duration(days: 200)).toIso8601String(),
        "begin": DateTime.now()
            .subtract(new Duration(days: 200))
            .subtract(new Duration(days: 45))
            .toIso8601String()
      }
    ]);

    var events = [];
    (json.decode(rawEvents)).forEach((e) => {events.add(Event.fromJson(e))});

    return Scaffold(
      body: Container(
          margin: new EdgeInsets.all(8),
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  "Vos évènements",
                  style: Theme.of(context).textTheme.headline,
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final item = events[index];
                    initializeDateFormatting('fr_FR', null);
                    return CustomListItemTwo(
                      thumbnail: Container(
                        child: new Image.asset(
                          d[index],
                        ),

                      ),
                      title: item.getTitle(),
                      distance: 250.6,
                      beginDate: item.getBegin(),
                      description: item.getDescription(),
                      endDate: item.getEnd(),
                      type: item.getType(),
                    );
                  },
                ))
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        backgroundColor: Colors.amber,
        onPressed: () async {
          final BluetoothDevice selectedDevice = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) {
            return SelectBondedDevicePage(checkAvailability: false);
          }));

          //BluetoothDevice s = new BluetoothDevice(selectedDevice.name,)

          if (selectedDevice != null) {
            await _startBackgroundTask(context, selectedDevice);
            setState(() {
              /* Update for `_collectingTask.inProgress` */
            });

          }
        },
      ),
    );
  }
}


BackgroundCollectingTask _collectingTask;

Future<void> _startBackgroundTask(BuildContext context, BluetoothDevice server) async {
  try {
    _collectingTask = await BackgroundCollectingTask.connect(server);
    await _collectingTask.start();
  }
  catch (ex) {
    if (_collectingTask != null) {
      _collectingTask.cancel();
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error occured while connecting'),
          content: Text("${ex.toString()}"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
