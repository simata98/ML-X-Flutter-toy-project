import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

Future addFlowerTime() async {
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
    'name': FieldValue.arrayUnion([name]),
  });
}

Future<void> addFlowerPoint() async {
  try {
    print("1");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    String strX = position.latitude.toString();
    String strY = position.longitude.toString();
    final _collectionRef = await FirebaseFirestore.instance
        .collection('flowers')
        .doc('6K9W1muEMmJoyKzulzdL');
    await _collectionRef.update({
      'pointX': FieldValue.arrayUnion([strX])
    });
    await _collectionRef.update({
      'pointY': FieldValue.arrayUnion([strY])
    });
  } catch (e) {
    print("3");
    print(e);
  }
}

Future<void> addFlowerImage(File image) async {
  final _collectionRef = await FirebaseFirestore.instance
      .collection('flowers')
      .doc('6K9W1muEMmJoyKzulzdL');
  await _collectionRef.update({
    'image': FieldValue.arrayUnion([image.path])
  });
}
