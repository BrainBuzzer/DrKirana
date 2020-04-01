import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProfileEditPage extends StatefulWidget {
  final DocumentSnapshot doc;
  final String uid;
  UserProfileEditPage({Key key, this.doc, this.uid}): super(key: key);

  @override
  _UserProfileEditPageState createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  final _formKey = GlobalKey<FormState>();

  String name, address;

  void initState() {
    setState(() {
      name = widget.doc['name'];
      address = widget.doc['address'];
    });
    super.initState();
  }

  void _submitForm(BuildContext context) {
    Firestore.instance.collection('users').document(widget.uid).updateData({
      'name': name,
      'address': address
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(title: Text("User Profile")),
        body: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Center(
                    child: Center(
                      child: TextFormField(
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          initialValue: name,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter your name',
                            labelText: 'Name',
                          ),
                          onChanged: (val) {
                            setState(() {
                              this.name = val;
                            });
                          }),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: TextFormField(
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                        initialValue: address,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Enter your address',
                          labelText: 'Address',
                        ),
                        onChanged: (val) {
                          setState(() {
                            this.address = val;
                          });
                        })),
                RaisedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _submitForm(context);
                    }
                  },
                  icon: Icon(Icons.check),
                  label: Text("Submit"),
                  color: Colors.blue,
                  textColor: Colors.white,
                )
              ],
            )));
  }
}
