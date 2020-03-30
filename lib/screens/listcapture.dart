import 'dart:io';

import 'package:dr_kirana/screens/uploader.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:after_layout/after_layout.dart';

class ListCapturePage extends StatefulWidget {
  final String type;

  ListCapturePage ({ this.type });

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
    File selected = await ImagePicker.pickImage(source: ImageSource.camera);

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
                ? Card(
                child: new InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                      child: new Text('Capture List')
                    )
                  ),
                  onTap: _captureImage,
                )
              ) : Image.file(_imageFile),
              Uploader(file: _imageFile, type: widget.type)
            ]
          )
        )
      )
    );
  }
}
