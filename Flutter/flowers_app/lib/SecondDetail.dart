import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:math';

class SecondDetail extends StatefulWidget {
  const SecondDetail({Key? key}) : super(key: key);

  @override
  _SecondDetailState createState() => _SecondDetailState();
}

class _SecondDetailState extends State<SecondDetail> {
  Completer<GoogleMapController> _controller = Completer();

  List<Marker> _markers = [];
  List<Polyline> _line = [];
  bool tf = true;
  static LatLng currentPosition = LatLng(41.017901, 28.847953);

  @override
  void initState() {
    _checkPermission();
    _getUserLocation();
    super.initState();
  }

  void _getUserLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  static CameraPosition _start = CameraPosition(
    target: currentPosition,
    zoom: 14,
  );

  static final CameraPosition _univ =
      CameraPosition(target: currentPosition, zoom: 14);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _start,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _markers.toSet(),
        onTap: (pos) {
          addMark(pos);
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            FloatingActionButton.extended(
              onPressed: _goToUniv,
              label: Text('현재 위치'),
              icon: Icon(Icons.donut_large),
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      } else {}
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are parmenently denied, we cannot request permissions');
    }
  }

  Future<void> _goToUniv() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_univ));
  }

  addMark(pos) {
    int id = Random().nextInt(100);
    setState(() {
      _markers.add(Marker(position: pos, markerId: MarkerId(id.toString())));
      // if (tf) {
      //   _markers.clear();
      //   _markers.add(Marker(position: pos, markerId: MarkerId(id.toString())));
      //   tf = !tf;
      // } else {
      //   _markers.add(Marker(
      //       position: pos,
      //       markerId: MarkerId('2'),
      //       icon: BitmapDescriptor.defaultMarkerWithHue(
      //           BitmapDescriptor.hueBlue)));
      //   tf = !tf;
      // }
    });
  }
}
