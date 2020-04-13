import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_kirana/screens/user/dashboard.dart';
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

  String name, address, city;

  void initState() {
    setState(() {
      if(widget.doc != null) {
        name = widget.doc['name'];
        address = widget.doc['address'];
        city = widget.doc['city'];
      } else {
        name = '';
        address = '';
        city = "Latur";
      }
    });
    super.initState();
  }

  void _submitForm(BuildContext context) {
    if(widget.doc == null) {
      Firestore.instance.collection('users').document(widget.uid).setData({
        'name': name,
        'address': address + ' ' + city,
        'city': city,
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardPage()));
    } else {
      Firestore.instance.collection('users').document(widget.uid).updateData({
        'name': name,
        'address': address + ' ' + city,
        'city': city
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(title: Text("तुमची माहिती")),
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
                              return 'कृपया आपले नाव टाका';
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
                            hintText: 'आपले संपूर्ण नाव',
                            labelText: 'संपूर्ण नाव',
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
                            return 'कृपया आपला संपूर्ण पत्ता टाकावा';
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
                          hintText: 'आपला पत्ता',
                          labelText: 'पत्ता',
                        ),
                        onChanged: (val) {
                          setState(() {
                            this.address = val;
                          });
                        })),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: DropdownButton<String>(
                      value: this.city,
                      elevation: 5,
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(child: Text("लातूर"), value: "Latur"),
                      ],
                      onChanged: (value) {
                        setState(() {
                          this.city = value;
                        });
                      },
                    )),

                RaisedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _submitForm(context);
                    }
                  },
                  icon: Icon(Icons.check),
                  label: Text("पुष्टी करा"),
                  color: Colors.blue,
                  textColor: Colors.white,
                )
              ],
            )));
  }
}
