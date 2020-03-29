import 'dart:io';
import 'package:dr_kirana/services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class Uploader extends StatefulWidget {
  final File file;
  final String type;
  Uploader({Key key, this.file, this.type}) : super(key: key);
  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://dr-kirana-final.appspot.com/');

  StorageUploadTask _uploadTask;

  void _startUpload() {
    String filePath = 'images/${DateTime.now()}.png';

    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    AuthService().getCurrentUID().then((user) {
      geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
          setState(() {
            Firestore.instance.collection('orders').document()
              .setData({
                'location': {
                  'latitude': position.latitude,
                  'longitude': position.longitude
                },
                'uid': user.uid,
                'status': "placed",
                'image': filePath,
                'type': widget.type,
                'time_order_placed': DateTime.now()
              });
            _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
          });
        }).catchError((e) {
          print(e);
        });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (context, snapshot) {
          var event = snapshot?.data?.snapshot;

          double progressPercent = event != null
            ? event.bytesTransferred / event.totalByteCount
            : 0;

          return Column(
            children: <Widget>[
              if(_uploadTask.isComplete)
                Text('Order placed successfully. Please wait for the shopkeeper to call you.'),

              LinearProgressIndicator(value: progressPercent),
              Center(
                child: Text(
                  '${(progressPercent*100).toStringAsFixed(2)}'
                )
              )
            ],
          );
        }
      );
    } else {
      return widget.file != null ? FlatButton.icon(
        label: Text('Order this List'),
        icon: Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      ) : Container();
    }
  }
}
