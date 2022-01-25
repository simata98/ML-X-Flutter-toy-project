import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase.dart';
import 'fourthDetail.dart';
import 'dart:io';

class ThirdDetail extends StatefulWidget {
  _ThirdDetail createState() => _ThirdDetail();
}

class _ThirdDetail extends State<ThirdDetail> {
  String _searchText = "";
  TextEditingController _textStream = TextEditingController();
  String url = 'https://google.com';
  File? _image;
  String imageurl = "assets/images/ex.png";
  final picker = ImagePicker();
  List? _outputs;

  void _printTextEdit() {
    print('${_textStream.text}');
  }

  //앱이 실행될 때
  void initState() {
    super.initState();
    // loadModel().then((value) {
    //   setState(() {});
    // });
    loadModel().then((value) {
      setState(() {});
    });

    _textStream.addListener(_printTextEdit);
  }

  //앱이 종료될 때
  void dispose() {
    _textStream.dispose();
    Tflite.close();
    super.dispose();
  }

  void launchURL(url) async {
    await launch('https://ko.wikipedia.org/wiki/' + url,
        forceWebView: true, forceSafariVC: true);
  }

  //비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다
  Future getImage(ImageSource imageSource) async {
    final PickedFile = await picker.getImage(source: imageSource);
    if (PickedFile != null) {
      setState(() {
        _image = File(PickedFile.path); //가져온 이미지를 _image에 저장
      });
      await classifyImage(File(_image!.path));
    }

    recycleDialog();
  }

  // tflite 모델과 라벨 가져오기
  loadModel() async {
    await Tflite.loadModel(
      model: "assets/converted_model.tflite",
      labels: "assets/label.txt",
    ).then((value) {
      setState(() {
        //_loading = false;
      });
    });
  }

  // 이미지 분류
  Future classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 5, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );
    setState(() {
      _outputs = output;
      print(_outputs);
    });
  }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Container(
      padding: EdgeInsets.only(top: 8),
      width: 360,
      height: 400,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: _image == null
              ? Image(image: AssetImage('assets/images/ex.png'))
              : Image.file(File(_image!.path))),
    );
  }

  recycleDialog() {
    _image != null
        ? showDialog(
            context: context,
            barrierDismissible:
                false, // barrierDismissible - Dialog를 제외한 다른 화면 터치 x
            builder: (BuildContext context) {
              return AlertDialog(
                // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _outputs![0]['label'].toString().toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        background: Paint()..color = Colors.white,
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  Center(
                    child: new FlatButton(
                      child: new Text("Ok"),
                      onPressed: () {
                        // addFlowerPoint();
                        // addFlowerImage(_image!);
                        // addFlowerPoint();
                        // addFlowerTime();
                        // addFlowerName(
                        //     _outputs![0]['label'].toString().toUpperCase());
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              );
            })
        : showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "데이터가 없거나 잘못된 이미지 입니다.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  Center(
                    child: new FlatButton(
                      child: new Text("ok"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              );
            });
  }

  @override
  Widget build(BuildContext context) {
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
                                showImage(),
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
                                    _image = null;
                                    getImage(ImageSource.camera);
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
                                    _image = null;
                                    getImage(ImageSource.gallery);
                                  },
                                  icon: Icon(
                                    Icons.photo,
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
