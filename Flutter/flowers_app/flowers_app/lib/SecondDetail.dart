import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      appBar: AppBar(
        title: Text(
          "지도",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[600],
        elevation: 0,
      ),
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
            //   FloatingActionButton.extended(
            //     onPressed: _goToUniv,
            //     label: Text(
            //       '현재 위치',
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     icon: Icon(
            //       Icons.donut_large,
            //       color: Colors.white,
            //     ),
            //   ),
            //   SizedBox(
            //     width: 10,
            //   )
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

  addMark(pos) async {
    // late BitmapDescriptor myIcon;
    Uint8List iconData = await getBytesFromAsset('assets/images/flower.png');
    int id = Random().nextInt(9999);
    // BitmapDescriptor.fromAssetImage(
    //         ImageConfiguration(size: Size(1, 1)), 'assets/images/flower.png')
    //     .then((onValue) {
    //   myIcon = onValue;
    // });

    setState(() {
      _markers.add(Marker(
          position: pos,
          markerId: MarkerId(id.toString()),
          infoWindow: InfoWindow(
            title: 'firebase이름',
            snippet: 'firebase 설명',
          ),
          icon: BitmapDescriptor.fromBytes(iconData)

          // icon: await getMarkerIcon(
          //     "./assets/images/ex.png", Size(150.0, 150.0))
          ));
    });
  }

  Future<Uint8List> getBytesFromAsset(String path) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: 120);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
