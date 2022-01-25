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

//firebase
import 'package:cloud_firestore/cloud_firestore.dart';

class Flowers {
  List flowerName = [];
  List flowerTime = [];
  List positionX = [];
  List positionY = [];
  List image = [];

  Flowers(
      List flowerN, List flowerT, List positionX, List positionY, List image) {
    this.flowerName = flowerN;
    this.flowerTime = flowerT;
    this.positionX = positionX;
    this.positionY = positionY;
    this.image = image;
  }
}

class SecondDetail extends StatefulWidget {
  const SecondDetail({Key? key}) : super(key: key);

  @override
  _SecondDetailState createState() => _SecondDetailState();
}

class _SecondDetailState extends State<SecondDetail> {
  Completer<GoogleMapController> _controller = Completer();

  List<Marker> _markers = [];
  bool tf = true;
  static LatLng currentPosition = LatLng(36.77477477477478, 126.93671366081676);

  //firebase에서 가져오는 데이터에대한 매개변수
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String text = "";
  List flowerName = [];
  List flowerTime = [];
  List flowerPosX = [];
  List flowerPosY = [];
  List flowerimage = [];

  @override
  void initState() {
    //_checkPermission();
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

  static final CameraPosition _univ = CameraPosition(
      target: LatLng(36.77477477477478, 126.93671366081676), zoom: 14);

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
      body: FutureBuilder(
        future: getFlower(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _univ,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                addMark();
                print('fdkaljfldkafjldafjlkdfjlajfdlkaj');
              },
              onTap: (pos) {
                addMark();
                print(11);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers.toSet(),
            );
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 15),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      // body: GoogleMap(
      //   mapType: MapType.normal,
      //   initialCameraPosition: _start,
      //   onMapCreated: (GoogleMapController controller) {
      //     _controller.complete(controller);
      //     addMark();
      //   },
      //   myLocationEnabled: true,
      //   myLocationButtonEnabled: true,
      //   markers: _markers.toSet(),
      // ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }


  addMark() async {
    getFlower();
    Uint8List iconData = await getBytesFromAsset('assets/images/flower.png');

    setState(() {
      for (int i = 0; i < flowerName.length; ++i) {
        var lat = double.parse(flowerPosX[i]);
        var lng = double.parse(flowerPosY[i]);
        print(lat);
        print(lng);
        _markers.add(Marker(
            position: LatLng(lat, lng),
            // position: LatLng(36.77477477477478, 126.93671366081676),
            markerId: MarkerId(i.toString()),
            infoWindow: InfoWindow(
              title: '꽃 이름 : ${flowerName[i]}',
              snippet: '저장한 시간 : ${flowerTime[i]}',
            ),
            icon: BitmapDescriptor.fromBytes(iconData)));
      }
      print(flowerPosX);
    });
  }

//이미지파일 크기 변환
  Future<Uint8List> getBytesFromAsset(String path) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: 120);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

//firebase와 연결하는 함수
  Future<Flowers> getFlower() async {
    List _flowersN = [];
    List _flowersT = [];
    List<dynamic> _positionX = [];
    List<dynamic> _positionY = [];
    List _image = [];

    final _collectionRef = FirebaseFirestore.instance
        .collection('flowers')
        .doc('6K9W1muEMmJoyKzulzdL');

    var _docSnapshotN = await _collectionRef.get();
    _flowersN = _docSnapshotN['name'];
    var _docSnapshotT = await _collectionRef.get();
    _flowersT = _docSnapshotT['time'];
    var _docSnapshotP = await _collectionRef.get();
    _positionX = _docSnapshotP['pointX'];
    _positionY = _docSnapshotP['pointY'];
    var _docSnapshotI = await _collectionRef.get();
    _image = _docSnapshotI['image'];

    timestampToDate(_flowersT);

    flowerTime = _flowersT;
    flowerName = _flowersN;
    flowerPosX = _positionX;
    flowerPosY = _positionY;
    flowerimage = _image;

    Flowers flowers = new Flowers(
        flowerName, flowerTime, flowerPosX, flowerPosY, flowerimage);

    return flowers;
  }

  void timestampToDate(List flowerTime) {
    print("${flowerTime.length}");
    for (int i = 0; i < flowerTime.length; ++i) {
      flowerTime[i] = DateTime.parse(flowerTime[i].toDate().toString());
    }
  }
}
