import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatelessWidget {
  DocumentSnapshot order;
  String url;
  OrderDetailPage({Key key, this.order}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("ऑर्डर माहिती")
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          //TODO: Add order details
        )
      )
    );
  }
}
