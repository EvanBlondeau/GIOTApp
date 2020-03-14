import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:latlong/latlong.dart' as calc;

import 'Objects/Geoloc.dart';
import 'maps.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  final calc.Distance distance = new calc.Distance();

  static Geoloc _g1 = Geoloc.fromValues(13.035606, 77.562381, 20,
      new DateTime.now().subtract(new Duration(minutes: 5)));
  static Geoloc _g2 = Geoloc.fromValues(13.070632, 77.693071, 25,
      new DateTime.now().subtract(new Duration(minutes: 10)));
  static Geoloc _g3 = Geoloc.fromValues(12.970387, 77.693621, 28,
      new DateTime.now().subtract(new Duration(minutes: 13)));
  static Geoloc _g4 = Geoloc.fromValues(12.858433, 77.575691, 30,
      new DateTime.now().subtract(new Duration(minutes: 17)));
  static Geoloc _g5 = Geoloc.fromValues(12.948029, 77.472936, 45,
      new DateTime.now().subtract(new Duration(minutes: 25)));
  static Geoloc _g6 = Geoloc.fromValues(13.069280, 77.455844, 30,
      new DateTime.now().subtract(new Duration(minutes: 28)));

  List<Geoloc> GeolocList = List();
  List<LatLng> latlngSegment1 = List();
  var altTimeList = [
    new TimeSeriesAlt(_g1.getDateTime(), _g1.getAltitude()),
    new TimeSeriesAlt(_g2.getDateTime(), _g2.getAltitude()),
    new TimeSeriesAlt(_g3.getDateTime(), _g3.getAltitude()),
    new TimeSeriesAlt(_g4.getDateTime(), _g4.getAltitude()),
    new TimeSeriesAlt(_g5.getDateTime(), _g5.getAltitude()),
    new TimeSeriesAlt(_g6.getDateTime(), _g6.getAltitude()),
  ];

  @override
  Widget build(BuildContext context) {
    GeolocList.addAll([_g1, _g2, _g3, _g4, _g5, _g6]);
    GeolocList.forEach((element) => latlngSegment1.add(element.toLatLng()));

    var km = 0.0;
    for (var i = 0; i < GeolocList.length - 1; i++) {
      km += distance.as(
          calc.LengthUnit.Meter,
          new calc.LatLng(
              GeolocList[i].getLatitude(), GeolocList[i].getLongitude()),
          new calc.LatLng(GeolocList[i + 1].getLatitude(),
              GeolocList[i + 1].getLongitude()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Détails de l'évènement"),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Text("RoadTrip 2019",
                style: Theme.of(context).textTheme.headline6),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text("Trajet parcouru",)
          ),
          Container(
            height: 200,
            child: Maps(latLngList: latlngSegment1),
          ),

          Container(
              padding: EdgeInsets.all(10),
              child: Text("Tableau récapitulatif",)
          ),

          Table(
            defaultColumnWidth: FixedColumnWidth(5.0),
            border: TableBorder(
              horizontalInside: BorderSide(
                color: Colors.black,
                style: BorderStyle.solid,
                width: 1.0,
              ),
              verticalInside: BorderSide(
                color: Colors.black,
                style: BorderStyle.solid,
                width: 1.0,
              ),
            ),
            children: [
              _buildTableRow("Description, road trip entre amies"),
              _buildTableRow("Date de début, 12 juin 2019"),
              _buildTableRow("Date de fin, 27 juill 2019 "),
              _buildTableRow("Distance parcouru, $km"),

            ],
          ),
          Container(
              padding: EdgeInsets.all(10),
              child: Text("Denivelé",)
          ),
          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4),
                child: Container(
                  height: 200,
                  child: TimeSeriesChart([
                    new Series<TimeSeriesAlt, DateTime>(
                        id: 'Altitude',
                        data: altTimeList,
                        domainFn: (TimeSeriesAlt alt, _) => alt.time,
                        measureFn: (TimeSeriesAlt alt, _) => alt.altitude)
                  ], animate: true),
                ),
              )),
          //BarChartSample1(),
          //TODO: Patch distance increased on hot reload (?)
        ],
      ),
    );
  }
}

class TimeSeriesAlt {
  final DateTime time;
  final double altitude;

  TimeSeriesAlt(this.time, this.altitude);
}

TableRow _buildTableRow(String listOfNames) {
  return TableRow(
    children: listOfNames.split(',').map((name) {
      return Container(
        alignment: Alignment.center,
        child: Text(name, style: TextStyle(fontSize: 10.0)),
        padding: EdgeInsets.all(8.0),
      );
    }).toList(),
  );
}
