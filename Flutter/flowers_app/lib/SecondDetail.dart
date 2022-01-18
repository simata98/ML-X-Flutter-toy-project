import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('MAP'),
        backgroundColor: Colors.lightGreen[600],
      ),
      child: Container(
          child: Center(
        child: Text(""),
      )),
    );
  }
}
