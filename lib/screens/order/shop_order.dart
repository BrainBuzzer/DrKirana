import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_kirana/screens/order/uploader.dart';
import 'package:dr_kirana/screens/order/user_cart.dart';
import 'package:dr_kirana/store/cart/cart.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ShopOrderPage extends StatefulWidget {
  final DocumentSnapshot shop;
  final String type;

  ShopOrderPage({Key key, @required this.type, @required this.shop})
      : super(key: key);

  @override
  _ShopOrderPageState createState() => _ShopOrderPageState();
}

class _ShopOrderPageState extends State<ShopOrderPage> {
  File _imageFile;
  TextEditingController quantityController;
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    quantityController = TextEditingController();
    quantityController.text = "1";
    super.initState();
  }

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

  showQuantityEditDialog(BuildContext context, DocumentSnapshot doc) {
    final cart = Provider.of<Cart>(context, listen: false);
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        quantityController.clear();
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("अॅड करा"),
      onPressed: () {
        if (key.currentState.validate()) {
          cart.addOrEditItem(doc, quantityController.text);
          Navigator.pop(context);
          quantityController.clear();
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Form(
        key: key,
        child: TextFormField(
          controller: quantityController,
          autovalidate: true,
          validator: (val) {
            if (val.isEmpty) {
              return "कृपया आपल्याला हवे असलेले प्रमाण टाका";
            } else if (int.parse(val) <= 0) {
              return "1 किवा त्यापेक्षा अधिक वस्तु मागणी करा";
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(90),
            ),
            fillColor: Colors.white,
            filled: true,
            labelText: "प्रमाण टाका",
            hintText: 'प्रमाण टाका',
            suffixText: doc.data['size']['unit'],
          ),
          keyboardType: TextInputType.number,
        ),
      ),
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
    final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: new AppBar(
        title: new Text("ऑर्डर करा"),
        actions: <Widget>[
          new Stack(
            children: <Widget>[
              new IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => UserCart(shop: widget.shop)));
                  }),
              new Positioned(
                right: 11,
                top: 11,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Observer(
                    builder: (_) => Text(
                      '${cart.numberOfItems}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      body: Container(
          child: _imageFile == null
              ? Column(
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
                      Expanded(child: _buildShopItems(context)),
                      FlatButton.icon(
                          label: Text("दुसरे दुकान निवडा"),
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ])
              : Container(
                  child: Center(
                    child: Column(children: <Widget>[
                      Image.file(
                        _imageFile,
                        height: MediaQuery.of(context).size.height / 1.5,
                        width: MediaQuery.of(context).size.width / 1.5,
                      ),
                      Uploader(
                          file: _imageFile,
                          type: widget.type,
                          shop: widget.shop.documentID)
                    ]),
                  ),
                )),
    );
  }

  Widget _buildShopItems(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Container(
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('shops')
              .document(widget.shop.documentID)
              .collection('menu')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: new Text(snapshot.data.documents[index]['name']),
                    subtitle: new Text(
                        "${snapshot.data.documents[index]['size']['qty']} ${snapshot.data.documents[index]['size']['unit']} - ₹${snapshot.data.documents[index]['price']}"),
                    trailing: ClipOval(
                        child: Container(
                            color: Colors.green,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.add, color: Colors.white),
                            ))),
                    onTap: () {
                      if (cart.shop == widget.shop.documentID ||
                          cart.shop != null) {
                        showQuantityEditDialog(
                            context, snapshot.data.documents[index]);
                      } else {
                        cart.setShop(widget.shop.documentID);
                        showQuantityEditDialog(
                            context, snapshot.data.documents[index]);
                      }
                    },
                  );
                });
          }),
    );
  }
}
