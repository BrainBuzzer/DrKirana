import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_kirana/screens/order/image_view.dart';
import 'package:dr_kirana/screens/order/uploader.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ListCapturePage extends StatefulWidget {
  final DocumentSnapshot shop;
  final String type;

  ListCapturePage({Key key, @required this.type, @required this.shop})
      : super(key: key);

  @override
  _ListCapturePageState createState() => _ListCapturePageState();
}

class _ListCapturePageState extends State<ListCapturePage> {
  File _imageFile;

  // ignore: missing_return
  Future<File> _checkIfPaper(File image, BuildContext context) async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    bool status;
    final ImageLabeler labeler = FirebaseVision.instance
        .imageLabeler(ImageLabelerOptions(confidenceThreshold: 0.65));
    final List<ImageLabel> labels = await labeler.processImage(visionImage);

    for (ImageLabel label in labels) {
      if (label.text == 'Paper') {
        status = true;
      } else {
        status = false;
      }
    }

    return status ? image : showAlertDialog(context);
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("पुन्हा प्रयत्न करा"),
      onPressed: () {
        Navigator.pop(context);
        _captureImage(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ERROR"),
      content: Text(
          "आपण वापरलेल्या फोटोमध्ये यादी दिसून येत नाही. कृपया पुन्हा प्रयत्न करा."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _captureImage(BuildContext context) async {
    File selected = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    File image = await _checkIfPaper(selected, context);

    setState(() {
      _imageFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("ऑर्डर करा"),
      ),
      body: Center(
          child: Center(
              child: Column(children: <Widget>[
        _imageFile == null
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: Icon(Icons.info, color: Colors.blue),
                                  title: Text(
                                    widget.shop["note"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                              if (widget.shop['menu'] != null)
                                Container(
                                  color: Colors.blue,
                                  child: ListTile(
                                    title: Text(
                                      "आजचे भावफलक पहा",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    leading: Icon(
                                      Icons.restaurant_menu,
                                      color: Colors.white,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ImageView(
                                                  imageLocation:
                                                      widget.shop['menu'])));
                                    },
                                  ),
                                ),
                              Container(
                                color: Colors.green,
                                child: ListTile(
                                  title: Text(
                                    "आपल्या यादीची फोटो काढा",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  leading: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    _captureImage(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      FlatButton.icon(
                          label: Text("दुसरे दुकान निवडा"),
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ]),
              )
            : Container(
                child: Image.file(
                  _imageFile,
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width / 1.5,
                ),
              ),
        Uploader(
            file: _imageFile, type: widget.type, shop: widget.shop.documentID)
      ]))),
    );
  }
}
