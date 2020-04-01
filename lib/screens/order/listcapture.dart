import 'dart:io';

import 'package:dr_kirana/screens/order/uploader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:after_layout/after_layout.dart';

class ListCapturePage extends StatefulWidget {
  final String type, shop;

  ListCapturePage ({ Key key, this.type, this.shop }) : super(key: key);

  @override
  _ListCapturePageState createState() => _ListCapturePageState();
}

class _ListCapturePageState extends State<ListCapturePage> with AfterLayoutMixin<ListCapturePage> {
  File _imageFile;

  @override
  void afterFirstLayout(BuildContext context) {
    _captureImage();
  }
  
  Future<void> _captureImage() async {
    File selected = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _imageFile = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Dr Kirana"),
      ),
      body: Center(
        child: Center(
          child: Column(
            children: <Widget>[
              _imageFile == null
                ? Expanded(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton.icon(
                      label: Text("Capture List"),
                      icon: Icon(Icons.camera_alt),
                      onPressed: _captureImage,
                    ),
                    RaisedButton.icon(
                      label: Text("Select Shop Again"),
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      }
                    ),
                  ]
                )
              ) : Image.file(_imageFile),
              Uploader(file: _imageFile, type: widget.type, shop: widget.shop)
            ]
          )
        )
      )
    );
  }
}
