import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:toast/toast.dart';

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Ble(),
    );
  }
}

class Ble extends StatefulWidget {
  @override
  BleState createState() => BleState();
}

class BleState extends State<Ble> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  BluetoothDevice _device;
  bool _connected = false;
  List<BluetoothDevice> _devicesList = [];
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  BluetoothDevice device;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Flutter Bluetooth"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        // Defining a Column containing FOUR main Widgets wrapped with some padding:
        // 1. Text
        // 2. Row
        // 3. Card
        // 4. Text (wrapped with "Expanded" and "Padding")
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "PAIRED DEVICES",
                style: TextStyle(fontSize: 24, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              // Defining a Row containing THREE main Widgets:
              // 1. Text
              // 2. DropdownButton
              // 3. RaisedButton
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Device:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton(
                    // To be implemented : _getDeviceItems()
                    items: _getDeviceItems(),
                    onChanged: (value) => setState(() => _device = value),
                    value: _device,
                  ),
                  RaisedButton(
                    onPressed:
                    // To be implemented : _disconnect and _connect
                    _pressed ? null : _connected ? _disconnect : _connect,
                    child: Text(_connected ? 'Disconnect' : 'Connect'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  // Defining a Row containing THREE main Widgets:
                  // 1. Text (wrapped with "Expanded")
                  // 2. FlatButton
                  // 3. FlatButton
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "DEVICE 1",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed:
                        // To be implemented : _sendOnMessageToBluetooth()
                        _connected ? _sendOnMessageToBluetooth : null,
                        child: Text("ON"),
                      ),
                      FlatButton(
                        onPressed:
                        // To be implemented : _sendOffMessageToBluetooth()
                        _connected ? _sendOffMessageToBluetooth : null,
                        child: Text("OFF"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    "NOTE: If you cannot find the device in the list, "
                        "please turn on bluetooth and pair the device by "
                        "going to the bluetooth settings",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    bluetoothConnectionState();
  }

  // We are using async callback for using await
  Future<void> bluetoothConnectionState() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    devices = await bluetooth.getBondedDevices();


    // For knowing when bluetooth is connected and when disconnected
    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        default:
          print(state);
          break;
      }
    });

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  // Create the List of devices to be shown in Dropdown Menu
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  // Method to connect to bluetooth
  void _connect() {
    if (_device == null) {
      Toast.show('No device selected', context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth
              .connect(_device)
              .timeout(Duration(seconds: 10))
              .catchError((error) {
            setState(() => _pressed = false);
          });
          setState(() => _pressed = true);
        }
      });
    }
  }

  // Method to disconnect bluetooth
  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _pressed = true);
  }

  // Method to send message,
  // for turning the bletooth device on
  void _sendOnMessageToBluetooth() {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.write("1");
        Toast.show('Device Turned On', context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

      }
    });
  }

  // Method to send message,
  // for turning the bletooth device off
  void _sendOffMessageToBluetooth() {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.write("0");

        Toast.show('Device Turned Off', context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

      }
    });
  }
}
