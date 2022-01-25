import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class FourthDetail extends StatefulWidget {
  _FourthDetail createState() => _FourthDetail();
}

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

class _FourthDetail extends State<FourthDetail> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String text = "";
  List flowerName = [];
  List flowerTime = [];
  List flowerPosX = [];
  List flowerPosY = [];
  List flowerimage = [];

  void initState() {
    super.initState();
  }

  void timestampToDate(List flowerTime) {
    print("${flowerTime.length}");
    for (int i = 0; i < flowerTime.length; ++i) {
      flowerTime[i] = DateTime.parse(flowerTime[i].toDate().toString());
    }
  }

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

  @override
  Widget build(BuildContext context) {
    timestampToDate(flowerTime);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Flower Log",
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
            return ListView.builder(
                itemCount: flowerName.length,
                itemBuilder: (BuildContext context, int index) {
                  return Expanded(
                      child: Container(
                    height: 80,
                    child: Row(
                      children: [
                        flowerimage[index] == null
                            ? Image(image: AssetImage('assets/images/ex.png'))
                            : Image.file(File(flowerimage[index])),
                        Container(
                          child: Column(
                            children: [
                              Text("꽃 이름 : ${flowerName[index]} "),
                              Text("저장한 시간 : ${flowerTime[index]} "),
                              Text("위도 : ${flowerPosX[index]}"),
                              Text("경도 : ${flowerPosY[index]}"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ));
                });
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
    );
  }

  void _showDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text('선택완료'),
          content: Text('$text 항목을 선택했습니다'),
        );
      },
    );
  }

  Widget flowerList() {
    return ListTile(
      leading: Image(image: AssetImage('assets/images/ex.png')),
      title: Text("예시"),
      onTap: () => _showDialog(context, '예시'),
    );
  }
}
