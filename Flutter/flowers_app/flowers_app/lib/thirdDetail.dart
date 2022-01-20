import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ThirdDetail extends StatefulWidget {
  _ThirdDetail createState() => _ThirdDetail();
}

class _ThirdDetail extends State<ThirdDetail> {
  String _searchText = "";
  TextEditingController _textStream = TextEditingController();
  String url = 'https://google.com';

  void _printTextEdit() {
    print('${_textStream.text}');
  }

  void initState() {
    super.initState();

    _textStream.addListener(_printTextEdit);
  }

  void dispose() {
    _textStream.dispose();
    super.dispose();
  }

  void launchURL(url) async {
    await launch('https://ko.wikipedia.org/wiki/' + url,
        forceWebView: true, forceSafariVC: true);
  }

  void _loadPengsooIMG() {
    setState(() {
      url = "assets/images/ex.png";
    });
  }

  @override
  Widget build(BuildContext context) {
    String url = "assets/images/empty.png";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "메인화면",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: new IconThemeData(color: Colors.white, size: 35),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[600],
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.lightGreen[600],
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: TextField(
                      style: TextStyle(
                        fontSize: 17,
                      ),
                      controller: _textStream,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '찾고 싶은 꽃을 검색하세요',
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      launchURL(_textStream.text);
                      print('${_textStream.text}');
                      _textStream.clear();
                    },
                    icon: Icon(
                      Icons.search,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Stack(
                children: [
                  Container(
                    color: Colors.lightGreen[600],
                    width: 450,
                    height: 555,
                  ),
                  Container(
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "current flower",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            child: Stack(
                              children: [
                                Container(
                                  width: 360,
                                  height: 410,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey[800],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  width: 340,
                                  height: 390,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Image(
                                    width: 330,
                                    height: 370,
                                    image: AssetImage(url),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 67,
                                ),
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    print('Camera');
                                    _loadPengsooIMG();
                                  },
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.blueGrey[700],
                                  ),
                                  label: Text(
                                    "Camera",
                                    style: TextStyle(
                                      color: Colors.blueGrey[800],
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    print('gallery');
                                  },
                                  icon: Icon(
                                    Icons.photo_album,
                                    color: Colors.blueGrey[700],
                                  ),
                                  label: Text(
                                    "Gallery",
                                    style: TextStyle(
                                      color: Colors.blueGrey[800],
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  // Image(
                  //   image: AssetImage('assets/images/empty.png'),
                  //   width: 200.0,
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
