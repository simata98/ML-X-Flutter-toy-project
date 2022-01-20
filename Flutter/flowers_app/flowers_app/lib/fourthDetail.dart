import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FourthDetail extends StatefulWidget {
  _FourthDetail createState() => _FourthDetail();
}

class _FourthDetail extends State<FourthDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "마이페이지",
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
    );
  }
}
