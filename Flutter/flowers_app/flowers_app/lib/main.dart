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
    controller = TabController(length: 3, vsync: this);
    controller.addListener(() {});
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
              color: Colors.lightGreen,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.home,
              size: 35,
              color: Colors.lightGreen,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.person,
              size: 35,
              color: Colors.lightGreen,
            ),
          ),
        ],
        controller: controller,
      ),
    );
  }
}
