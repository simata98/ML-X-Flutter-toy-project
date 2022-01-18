import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThirdDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('MAIN'),
        backgroundColor: Colors.lightGreen[600],
      ),
      child: Container(
          child: Center(
        child: Text(""),
      )),
    );
  }
}
