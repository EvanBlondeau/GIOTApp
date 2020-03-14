import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  final List<LatLng> latLngList;
  const Maps({Key key, this.latLngList}): super(key: key);


  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  GoogleMapController controller;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Container(
            height: 400,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: GoogleMap(
                //that needs a list<Polyline>
                polylines: _polyline,
                markers: _markers,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
                ].toSet(),
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: widget.latLngList.last,
                  zoom: 11.0,
                ),
                mapType: MapType.terrain,
              ),
            )));
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      controller = controllerParam;
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(widget.latLngList.last.toString()),
        //_lastMapPosition is any coordinate which should be your default
        //position when map opens up
        position: widget.latLngList.last,
        infoWindow: InfoWindow(
          title: 'Awesome Polyline tutorial',
          snippet: 'This is a snippet',
        ),
      ));

      _polyline.add(Polyline(
        polylineId: PolylineId('line1'),
        visible: true,
        //latlng is List<LatLng>
        points: widget.latLngList,
        width: 2,
        color: Colors.blue,
      ));
    });
  }
}
