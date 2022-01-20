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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.lightGreen,
              height: 49,
            ),
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
                    },
                    icon: Icon(
                      Icons.search,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
            ),
            Container(
              child: Stack(
                children: [
                  Image(
                    image: AssetImage('assets/images/empty.png'),
                    width: 200.0,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
