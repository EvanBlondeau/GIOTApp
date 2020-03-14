import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veliot/transition_route_observer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'HomePage.dart';
import 'SharePref.dart';
import 'custom_route.dart';
import 'dashboard.dart';
import 'discovery.dart';
import 'SelectBondedDevicePage.dart';
import 'ChatPage.dart';
import 'BackgroundCollectingTask.dart';
import 'BackgroundCollectedPage.dart';
import 'widgets/fade_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => new _MainPage();
}

class _MainPage extends State<MainPage>  with SingleTickerProviderStateMixin, TransitionRouteAware {

  void home() {
    Navigator.of(context).pushReplacement(FadePageRoute(
      builder: (context) => Home(),
    ));
  }

    void dash() {
      Navigator.of(context).pushReplacement(FadePageRoute(
        builder: (context) => DashboardScreen(),
      ));
  }

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";

  Timer _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  BackgroundCollectingTask _collectingTask;

  bool _autoAcceptPairingRequests = false;

  Animation<double> _headerScaleAnimation;
  AnimationController _loadingController;
  static const headerAniInterval =
  const Interval(.1, .3, curve: Curves.easeOut);
  final routeObserver = TransitionRouteObserver<PageRoute>();

  @override
  void initState() {
    super.initState();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );

    _headerScaleAnimation =
        Tween<double>(begin: .6, end: 1).animate(CurvedAnimation(
          parent: _loadingController,
          curve: headerAniInterval,
        ));

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() { _bluetoothState = state; });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBluetoothSerial.instance.isEnabled) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() { _address = address; });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() { _name = name; });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance.onStateChanged().listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _loadingController.dispose();
    super.dispose();
  }

  @override
  void didPushAfterTransition() => _loadingController.forward();

  AppBar _buildAppBar(ThemeData theme) {

    final menuBtn = IconButton(
      color: Colors.white,
      icon: const Icon(FontAwesomeIcons.dashcube),
      onPressed: () => dash(),
    );

    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.home),
      color:  Colors.white,
      onPressed: () => home(),
    );

    final title = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Hero(
              tag: "near.huscarl.loginsample.logo",
              child: Image.asset(
                'assets/velo.png',
                filterQuality: FilterQuality.high,
                height: 30,
              ),
            ),
          ),

          SizedBox(width: 20),
        ],
      ),
    );

    return AppBar(
      leading: FadeIn(
        child: menuBtn,
        controller: _loadingController,
        offset: .3,
        curve: headerAniInterval,
        fadeDirection: FadeDirection.startToEnd,
      ),
      actions: <Widget>[
        FadeIn(
          child: signOutBtn,
          controller: _loadingController,
          offset: .3,
          curve: headerAniInterval,
          fadeDirection: FadeDirection.endToStart,
        ),
      ],
      title: title,
      backgroundColor:  Colors.amberAccent,
      elevation: 0,
      textTheme: theme.accentTextTheme,
      iconTheme: theme.accentIconTheme,
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amberAccent,
            title: Text('Bluetooth settings'),
          ),
          body: Container(
            child: ListView(
              children: <Widget>[
                Divider(),
                ListTile(
                    title: const Text('General',style: TextStyle(fontWeight: FontWeight.bold , color: Colors.black, fontSize: 18),)

                ),
                SwitchListTile(
                  title: const Text('Enable Bluetooth'),
                  value: _bluetoothState.isEnabled,
                  onChanged: (bool value) {
                    // Do the request and update with the true value then
                    future() async { // async lambda seems to not working
                      if (value)
                        await FlutterBluetoothSerial.instance.requestEnable();
                      else
                        await FlutterBluetoothSerial.instance.requestDisable();
                    }
                    future().then((_) {
                      setState(() {});
                    });
                  },
                ),
                ListTile(
                  title: const Text('Bluetooth status'),
                  subtitle: Text(_bluetoothState.toString()),
                  trailing: RaisedButton(
                    child: const Text('Settings'),
                    color: Colors.amberAccent,
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0)
                    ),
                    onPressed: () {
                      FlutterBluetoothSerial.instance.openSettings();
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Local adapter address'),
                  subtitle: Text(_address),
                ),
                ListTile(
                  title: const Text('Local adapter name'),
                  subtitle: Text(_name),
                  onLongPress: null,
                ),
                ListTile(
                    title: _discoverableTimeoutSecondsLeft == 0 ? const Text("Discoverable") : Text("Discoverable for ${_discoverableTimeoutSecondsLeft}s"),
                    subtitle: const Text("Evan Blondeau"),
                    trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: _discoverableTimeoutSecondsLeft != 0,
                            onChanged: null,
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: null,
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () async {
                              print('Discoverable requested');
                              final int timeout = await FlutterBluetoothSerial.instance.requestDiscoverable(60);
                              if (timeout < 0) {
                                print('Discoverable mode denied');
                              }
                              else {
                                print('Discoverable mode acquired for $timeout seconds');
                              }
                              setState(() {
                                _discoverableTimeoutTimer?.cancel();
                                _discoverableTimeoutSecondsLeft = timeout;
                                _discoverableTimeoutTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
                                  setState(() {
                                    if (_discoverableTimeoutSecondsLeft < 0) {
                                      FlutterBluetoothSerial.instance.isDiscoverable.then((isDiscoverable) {
                                        if (isDiscoverable) {
                                          print("Discoverable after timeout... might be infinity timeout :F");
                                          _discoverableTimeoutSecondsLeft += 1;
                                        }
                                      });
                                      timer.cancel();
                                      _discoverableTimeoutSecondsLeft = 0;
                                    }
                                    else {
                                      _discoverableTimeoutSecondsLeft -= 1;
                                    }
                                  });
                                });
                              });
                            },
                          )
                        ]
                    )
                ),

                Divider(),
                ListTile(
                    title: const Text('Devices discovery and connection' ,style: TextStyle(fontWeight: FontWeight.bold , color: Colors.black, fontSize: 18))
                ),
                SwitchListTile(
                  title: const Text('Auto-try specific pin when pairing'),
                  subtitle: const Text('Pin 1234'),
                  value: _autoAcceptPairingRequests,
                  onChanged: (bool value) {
                    setState(() {
                      _autoAcceptPairingRequests = value;
                    });
                    if (value) {
                      FlutterBluetoothSerial.instance.setPairingRequestHandler((BluetoothPairingRequest request) {
                        print("Trying to auto-pair with Pin 1234");
                        if (request.pairingVariant == PairingVariant.Pin) {
                          return Future.value("1234");
                        }
                        return null;
                      });
                    }
                    else {
                      FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
                    }
                  },
                ),
                ListTile(
                  title: RaisedButton(
                      child: const Text('Explore discovered devices'),
                      color: Colors.amberAccent,
                      textColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0)
                      ),
                      onPressed: () async {
                        final BluetoothDevice selectedDevice = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) { return DiscoveryPage(); })
                        );

                        if (selectedDevice != null) {
                          print('Discovery -> selected ' + selectedDevice.address);
                        }
                        else {
                          print('Discovery -> no device selected');
                        }
                      }
                  ),
                ),
                ListTile(
                  title: RaisedButton(
                    child: const Text('Connect to paired device to chat'),
                    color: Colors.amberAccent,
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0)
                    ),
                    onPressed: () async {
                      final BluetoothDevice selectedDevice = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) { return SelectBondedDevicePage(checkAvailability: false); })
                      );

                      if (selectedDevice != null) {
                        print('Connect -> selected ' + selectedDevice.address);
                        _startChat(context, selectedDevice);
                      }
                      else {
                        print('Connect -> no device selected');
                      }
                    },
                  ),
                ),

                Divider(),
                ListTile(
                    title: const Text('Multiple connections example',style: TextStyle(fontWeight: FontWeight.bold , color: Colors.black, fontSize: 18))
                ),
                ListTile(
                  title: RaisedButton(
                    child: (
                        (_collectingTask != null && _collectingTask.inProgress)
                            ? const Text('Disconnect and stop background collecting')
                            : const Text('Connect to start background collecting')
                    ),
                    color: Colors.amberAccent,
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0)
                    ),
                    onPressed: () async {
                      if (_collectingTask != null && _collectingTask.inProgress) {
                        await _collectingTask.cancel();
                        setState(() {/* Update for `_collectingTask.inProgress` */});
                      }
                      else {
                        final BluetoothDevice selectedDevice = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) { return SelectBondedDevicePage(checkAvailability: false); })
                        );

                        if (selectedDevice != null) {
                          await _startBackgroundTask(context, selectedDevice);
                          setState(() {/* Update for `_collectingTask.inProgress` */});
                        }
                      }
                    },
                  ),
                ),
                ListTile(
                    title: RaisedButton(
                      child: const Text('View background collected data'),
                      color: Colors.amberAccent,
                      textColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0)
                      ),
                      onPressed: (_collectingTask != null) ? () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return ScopedModel<BackgroundCollectingTask>(
                                model: _collectingTask,
                                child: BackgroundCollectedPage(),
                              );
                            })
                        );
                      } : null,
                    )
                ),
              ],
            ),
          ),


        );


  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) { return ChatPage(server: server); }));
  }



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
}