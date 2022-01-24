import 'package:flowers_app/thirdDetail.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FourthDetail extends StatefulWidget {
  _FourthDetail createState() => _FourthDetail();
}

class Flowers {
  List flowerName = [];
  List flowerTime = [];

  Flowers(List flowerN, List flowerT) {
    this.flowerName = flowerN;
    this.flowerTime = flowerT;
  }
}

class _FourthDetail extends State<FourthDetail> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String text = "";
  List flowerName = [];
  List flowerTime = [];

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

    final _collectionRefN = FirebaseFirestore.instance
        .collection('flowers')
        .doc('6K9W1muEMmJoyKzulzdL');
    final _collectionRefT = FirebaseFirestore.instance
        .collection('flowers')
        .doc('6K9W1muEMmJoyKzulzdL');

    var _docSnapshotN = await _collectionRefN.get();
    _flowersN = _docSnapshotN['name'];
    var _docSnapshotT = await _collectionRefT.get();
    _flowersT = _docSnapshotT['time'];

    timestampToDate(_flowersT);

    flowerTime = _flowersT;
    flowerName = _flowersN;

    Flowers flowers = new Flowers(flowerName, flowerTime);

    return flowers;
  }

  Future addFlowerTime(String time) async {
    final _collectionRef = FirebaseFirestore.instance
        .collection('flowers')
        .doc('6K9W1muEMmJoyKzulzdL');
    _collectionRef.update({
      'time': FieldValue.arrayUnion([DateTime.now()])
    });
  }

  Future addFlowerName(String name) async {
    final _collectionRef = FirebaseFirestore.instance
        .collection('flowers')
        .doc('6K9W1muEMmJoyKzulzdL');
    _collectionRef.update({
      'name': FieldValue.arrayUnion([name])
    });
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
                padding: EdgeInsets.all(50),
                itemCount: flowerName.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        "꽃 이름 : ${flowerName[index]}  저장한 시간 : ${flowerTime[index]}"),
                  );
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
