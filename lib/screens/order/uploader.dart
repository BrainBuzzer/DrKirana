import 'dart:io';
import 'package:dr_kirana/services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';

class Uploader extends StatefulWidget {
  final File file;
  final String type, shop;
  Uploader({Key key, @required this.file, @required this.type, @required this.shop}) : super(key: key);
  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://dr-kirana-final.appspot.com/');
  String filePath;
  bool orderPlaced = false, locationService = true;
  StorageUploadTask _uploadTask;

  void _startUpload() {
    setState(() {
      filePath = 'images/${DateTime.now()}.png';
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
    _storeOrder();
  }

  Future<void> _storeOrder() async {
    FirebaseUser user = await AuthService().getCurrentUser();
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;

    PermissionStatus permission = await LocationPermissions().checkPermissionStatus();
    if(permission != PermissionStatus.granted) {
      permission = await LocationPermissions().requestPermissions();
    }

    Position position;

    ServiceStatus serviceStatus = await LocationPermissions().checkServiceStatus();
    if(serviceStatus != ServiceStatus.enabled) {
      DocumentSnapshot doc = await Firestore.instance.collection('users').document(user.uid).get();
      List<Placemark> placemark = await Geolocator().placemarkFromAddress(doc.data['address']);
      position = placemark[0].position;
      setState(() {
        locationService = false;
      });
    } else {
       position = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    }

    Firestore.instance.collection('orders').add({
      'location': {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'isAccurate': locationService ? true : false
      },
      'uid': user.uid,
      'phone_number': user.phoneNumber,
      'status': "placed",
      'image': filePath,
      'type': widget.type,
      'time_order_placed': DateTime.now(),
      'shop': widget.shop,
    });
    setState(() {
      orderPlaced = true;
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
                        orderPlaced ? 'Order Placed Successfully!' : 'Picture uploaded successfully. Please wait while we are placing you order.',
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
        color: Colors.green,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        textColor: Colors.white,
        icon: Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      ) : Container();
    }
  }
}
