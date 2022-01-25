import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';

import 'thirdDetail.dart';
import 'package:flutter/material.dart';
import 'SecondDetail.dart';
import 'fourthDetail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static String _title = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  State<StatefulWidget> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    initFirebase();
    _checkPermission();
    controller = TabController(initialIndex: 1, length: 3, vsync: this);
    controller.addListener(() {});
  }

  void initFirebase() async {
    print(await Firebase.initializeApp());
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[SecondDetail(), ThirdDetail(), FourthDetail()],
        controller: controller,
      ),
      bottomNavigationBar: TabBar(
        tabs: <Tab>[
          Tab(
            icon: Icon(
              Icons.pin_drop,
              size: 35,
              color: Colors.lightGreen[800],
            ),
          ),
          Tab(
            icon: Icon(
              Icons.home,
              size: 35,
              color: Colors.lightGreen[800],
            ),
          ),
          Tab(
            icon: Icon(
              Icons.person,
              size: 35,
              color: Colors.lightGreen[800],
            ),
          ),
        ],
        controller: controller,
      ),
    );
  }
}
