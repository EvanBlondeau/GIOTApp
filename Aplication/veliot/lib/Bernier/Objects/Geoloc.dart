import 'package:google_maps_flutter/google_maps_flutter.dart';

class Geoloc {
  double _latitude;
  double _longitude;
  double _altitude;
  DateTime _dateTime;

  double getAltitude(){
    return _altitude;
  }

  double getLatitude(){
    return _latitude;
  }

  double getLongitude() {
    return _longitude;
  }

  DateTime getDateTime(){
    return _dateTime;
  }
  void setAltitude(double alt){
    _altitude=alt;
  }

  void setLongitude(double long){
    _longitude=long;
  }

  void setLatitude(double lat){
    _latitude=lat;
  }

  void setDateTime(DateTime dateTime){
    _dateTime=dateTime;
  }

  Geoloc.fromValues(double lat, double long, double alt, DateTime dateTime){
    _dateTime=dateTime;
    _latitude=lat;
    _longitude=long;
    _altitude=alt;
  }

  Geoloc.fromJson(Map<String, dynamic> json):
        _dateTime = DateTime.parse(json['date']),
        _latitude = json['lat'].toDouble(),
        _longitude = json['long'].toDouble(),
        _altitude = json['altitude'].toDouble();

  LatLng toLatLng(){
    return new LatLng(_latitude, _longitude);
  }
}