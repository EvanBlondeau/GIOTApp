import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:veliot/MainPage.dart';
import 'package:veliot/SharePref.dart';
import 'BackgroundCollectingTask.dart';
import 'SelectBondedDevicePage.dart';
import 'custom_route.dart';
import 'transition_route_observer.dart';
import 'widgets/class_bluetooth.dart';
import 'widgets/fade_in.dart';

class DashboardScreen extends StatefulWidget {

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {

  Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed('/')
    // we dont want to pop the screen, just replace it completely
        .then((_) => false);
  }

  Future<bool> _Setting_ble(BuildContext context) {
    return Navigator.of(context)
        .pushReplacement(FadePageRoute(
      builder: (context) => MainPage(),
      ))
    // we dont want to pop the screen, just replace it completely
        .then((_) => false);
  }

  final routeObserver = TransitionRouteObserver<PageRoute>();
  static const headerAniInterval =
  const Interval(.1, .3, curve: Curves.easeOut);
  Animation<double> _headerScaleAnimation;
  AnimationController _loadingController;

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
      icon: const Icon(FontAwesomeIcons.bars),
      onPressed: () => _goToLogin(context),
    );

    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.bluetooth),
      color:  Colors.white,
      onPressed: () => _Setting_ble(context),
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
                'assets/vel.png',
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
      backgroundColor:  Colors.blueGrey,
      elevation: 0,
      textTheme: theme.accentTextTheme,
      iconTheme: theme.accentIconTheme,
    );
  }

  SharedPref sharedPref = SharedPref();
  Bluetooth_shared  ble_act = Bluetooth_shared();

  loadSharedPrefs() async {
    try {
      Bluetooth_shared ble = Bluetooth_shared.fromJson(await sharedPref.read("user"));
      setState(() {
        ble_act = ble;

            print("Loaded!");
      });
    } catch (Excepetion) {
      print("Nothing found!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () => _Setting_ble(context),
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(theme),
          body:  Container(
            child: ListView(
                children: <Widget>[
                Divider(),
                ListTile(
                title: const Text('General')
                ),

               ],
            ),
          ),

    ),
    ),
    );
  }
}
