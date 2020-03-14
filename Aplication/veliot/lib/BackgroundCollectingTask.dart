import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

class DataSample {
  double temperature1;
  double temperature2;
  double waterpHlevel;
  DateTime timestamp;

  DataSample(
      {this.temperature1,
      this.temperature2,
      this.waterpHlevel,
      this.timestamp});
}

Future<void> request(data) async {
  Response response;
  Dio dio = new Dio();
  response =
      await dio.post("http://192.168.43.68:3000/api/position", data: json);
  print(response.statusCode);
  return null;
}

class BackgroundCollectingTask extends Model {
  static BackgroundCollectingTask of(BuildContext context,
          {bool rebuildOnChange = false}) =>
      ScopedModel.of<BackgroundCollectingTask>(context,
          rebuildOnChange: rebuildOnChange);

  final BluetoothConnection _connection;
  List<int> _buffer = List<int>();

  // @TODO , Such sample collection in real code should be delegated
  // (via `Stream<DataSample>` preferably) and then saved for later
  // displaying on chart (or even stright prepare for displaying).
  List<DataSample> samples = List<
      DataSample>(); // @TODO ? should be shrinked at some point, endless colleting data would cause memory shortage.

  bool inProgress;

  BackgroundCollectingTask._fromConnection(this._connection) {
    _connection.input.listen((data) {
      _buffer += data;

      String dataString = String.fromCharCodes(data);
      print(" background task get " + dataString);

    //  var json = jsonDecode(dataString);
     // request(json);

      /* "date": {},
        "altitude": 70,
        "lat": 48.1567309,
        "long": -1.7255479*/

      int index = _buffer.indexOf('1'.codeUnitAt(0));
      //  print(" index"+ index.toString());
      //Toast.show("Toast plugin app", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
/*
        int backspacesCounter = 0;
        data.forEach((byte) {
          if (byte == 8 || byte == 127) {
            backspacesCounter++;
          }
        });
        Uint8List buffer = Uint8List(data.length - backspacesCounter);
        int bufferIndex = buffer.length;

        // Apply backspace control character
        backspacesCounter = 0;
        for (int i = data.length - 1; i >= 0; i--) {
          if (data[i] == 8 || data[i] == 127) {
            backspacesCounter++;
          }
          else {
            if (backspacesCounter > 0) {
              backspacesCounter--;
            }
            else {
              buffer[--bufferIndex] = data[i];
            }
          }
        }

        // Create message if there is new line character
        String dataString1 = String.fromCharCodes(data);
      //Toast.show('data : '+dataString, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

        print(dataString1);
*/
      /*  int index = buffer.indexOf(13);
        if (~index != 0) { // \r\n
          setState(() {
            messages.add(_Message(1,
                backspacesCounter > 0
                    ? _messageBuffer.substring(0, _messageBuffer.length - backspacesCounter)
                    : _messageBuffer
                    + dataString.substring(0, index)
            ));
            _messageBuffer = dataString.substring(index);
          });
        }
        else {
          _messageBuffer = (
              backspacesCounter > 0
                  ? _messageBuffer.substring(0, _messageBuffer.length - backspacesCounter)
                  : _messageBuffer
                  + dataString
          );
        }*/

      /*       if (index >= 0 && _buffer.length - index >= 7) {
          final DataSample sample = DataSample(
              temperature1: (_buffer[index + 1] + _buffer[index + 2] / 100),
              temperature2: (_buffer[index + 3] + _buffer[index + 4] / 100),
              waterpHlevel: (_buffer[index + 5] + _buffer[index + 6] / 100),
              timestamp: DateTime.now()
          );
          _buffer.removeRange(0, index + 7);

          samples.add(sample);
          notifyListeners(); // Note: It shouldn't be invoked very often - in this example data comes at every second, but if there would be more data, it should update (including repaint of graphs) in some fixed interval instead of after every sample.
          //print("${sample.timestamp.toString()} -> ${sample.temperature1} / ${sample.temperature2}");
        }
        // Otherwise break
        else {
          break;
        }*/
    }).onDone(() {
      inProgress = false;
      notifyListeners();
    });
  }

  static Future<BackgroundCollectingTask> connect(
      BluetoothDevice server) async {
    final BluetoothConnection connection =
        await BluetoothConnection.toAddress(server.address);
    return BackgroundCollectingTask._fromConnection(connection);
  }

  void dispose() {
    _connection.dispose();
  }

  Future<void> start() async {
    inProgress = true;
    _buffer.clear();
    samples.clear();
    notifyListeners();
    _connection.output.add(ascii.encode('start'));
    await _connection.output.allSent;
  }

  Future<void> cancel() async {
    inProgress = false;
    notifyListeners();
    _connection.output.add(ascii.encode('stop'));
    await _connection.finish();
  }

  Future<void> pause() async {
    inProgress = false;
    notifyListeners();
    _connection.output.add(ascii.encode('stop'));
    await _connection.output.allSent;
  }

  Future<void> reasume() async {
    inProgress = true;
    notifyListeners();
    _connection.output.add(ascii.encode('start'));
    await _connection.output.allSent;
  }

  Iterable<DataSample> getLastOf(Duration duration) {
    DateTime startingTime = DateTime.now().subtract(duration);
    int i = samples.length;
    do {
      i -= 1;
      if (i <= 0) {
        break;
      }
    } while (samples[i].timestamp.isAfter(startingTime));
    return samples.getRange(i, samples.length);
  }
}

/*
 int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      }
      else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        }
        else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    Toast.show('data : '+dataString, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    int index = buffer.indexOf(13);
    if (~index != 0) { // \r\n
      setState(() {
        messages.add(_Message(1,
            backspacesCounter > 0
                ? _messageBuffer.substring(0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer
                + dataString.substring(0, index)
        ));
        _messageBuffer = dataString.substring(index);
      });
    }
    else {
      _messageBuffer = (
          backspacesCounter > 0
              ? _messageBuffer.substring(0, _messageBuffer.length - backspacesCounter)
              : _messageBuffer
              + dataString
      );
    }
*/
