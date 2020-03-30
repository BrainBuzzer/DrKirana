import 'dart:io';
import 'package:dr_kirana/services/authservice.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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

  Future<Directory> getTemporaryDirectory() async {
    return Directory.systemTemp;
  }

  Future<File> compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 88,
      rotate: 180,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  Future<void> _startUpload() async {
    String filePath = 'images/${DateTime.now()}.png';

    final dir = await getTemporaryDirectory();
    final targetPath = dir.absolute.path + "/temp.jpg";
    final imgFile = await compressAndGetFile(widget.file, targetPath);

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
                'phone_number': user.phoneNumber,
                'status': "placed",
                'image': filePath,
                'type': widget.type,
                'time_order_placed': DateTime.now()
              });
            _uploadTask = _storage.ref().child(filePath).putFile(imgFile);
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

          return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  if(_uploadTask.isComplete)
                    Center(
                      child: Text(
                        'Order placed successfully. Please wait for the shopkeeper to call you.',
                        style: Theme.of(context).textTheme.title,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if(_uploadTask.isInProgress)
                    CircularProgressIndicator(),
                  LinearProgressIndicator(value: progressPercent),
                  Center(
                    child: Text(
                      '${(progressPercent*100).toStringAsFixed(2)}'
                    )
                  )
                ],
              )
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
