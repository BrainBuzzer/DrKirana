import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class Uploader extends StatefulWidget {
  final File file;
  final String type, shop;
  Uploader(
      {Key key, @required this.file, @required this.type, @required this.shop})
      : super(key: key);
  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://dr-kirana-final.appspot.com/');
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  FirebaseUser user;
  static final FacebookAppEvents facebookAppEvents = FacebookAppEvents();
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
    Position position;

    DocumentSnapshot doc =
        await Firestore.instance.collection('users').document(user.uid).get();
    if (doc.data['location'] == null) {
      List<Placemark> placemark =
          await Geolocator().placemarkFromAddress(doc.data['address']);
      position = placemark[0].position;
    } else {
      position = new Position(
          latitude: doc.data['location']['geopoint'].latitude,
          longitude: doc.data['location']['geopoint'].longitude);
    }

    Firestore.instance.collection('orders').add({
      'location': {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
      'uid': user.uid,
      'phone_number': user.phoneNumber,
      'status': "placed",
      'image': filePath,
      'type': widget.type,
      'time_order_placed': DateTime.now(),
      'shop': widget.shop,
      'cat': 'image'
    });

    facebookAppEvents.logEvent(name: "user_order_placed", parameters: {
      "time_order_placed": DateTime.now(),
      "shop": widget.shop,
      "uid": user.uid,
    });

    await analytics.logEcommercePurchase(origin: widget.type, currency: "INR");

    setState(() {
      orderPlaced = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      user = Provider.of<FirebaseUser>(context, listen: true);
    });
    if (user == null) {
      return Container(
        child: CircularProgressIndicator(),
      );
    }
    if (_uploadTask != null) {
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
                    if (_uploadTask.isComplete)
                      Center(
                        child: Text(
                          orderPlaced
                              ? 'ऑर्डर पाठवली'
                              : 'आम्ही आपली ऑर्डर पाठवत आहोत',
                          style: Theme.of(context).textTheme.title,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (_uploadTask.isInProgress) CircularProgressIndicator(),
                    LinearProgressIndicator(value: progressPercent),
                    Center(
                        child: Text(
                            '${(progressPercent * 100).toStringAsFixed(2)}'))
                  ],
                ));
          });
    } else {
      return widget.file != null
          ? FlatButton.icon(
              label: Text('ऑर्डर करा'),
              color: Colors.green,
              padding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              textColor: Colors.white,
              icon: Icon(Icons.cloud_upload),
              onPressed: () => _startUpload(),
            )
          : Container();
    }
  }
}
