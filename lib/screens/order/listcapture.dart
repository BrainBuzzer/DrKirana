import 'dart:io';
import 'package:dr_kirana/screens/order/uploader.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ListCapturePage extends StatefulWidget {
  final String type, shop;

  ListCapturePage ({ Key key, this.type, this.shop }) : super(key: key);

  @override
  _ListCapturePageState createState() => _ListCapturePageState();
}

class _ListCapturePageState extends State<ListCapturePage> {
  File _imageFile;

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
        title: new Text("Place Your Order"),
      ),
      body: Center(
        child: Center(
          child:  Column(
            children: <Widget>[
              _imageFile == null
                ? Column(
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
                ) : Container(
                  child: Image.file(
                    _imageFile,
                    height: MediaQuery.of(context).size.height/1.5,
                    width: MediaQuery.of(context).size.width/1.5,
                  ),
                ),
              Uploader(file: _imageFile, type: widget.type, shop: widget.shop)
            ]
          )
        )
      ),
    );
  }
}
