import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_kirana/screens/user/dashboard.dart';
import 'package:dr_kirana/screens/user/location_pick.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_geocoding/google_geocoding.dart';

class UserProfileEditPage extends StatefulWidget {
  final DocumentSnapshot doc;
  final String uid;
  final GeoFirePoint pos;
  UserProfileEditPage({Key key, this.doc, this.uid, this.pos}): super(key: key);

  @override
  _UserProfileEditPageState createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  final _formKey = GlobalKey<FormState>();

  String name, address;
  var addressController = TextEditingController();

  void initState() {
    setState(() {
      if(widget.doc != null) {
        name = widget.doc['name'];
        addressController.text = widget.doc['address'];
      } else {
        name = '';
        addressController.text = '';
      }
      var googleGeocoding = GoogleGeocoding("AIzaSyAaqhxRs-OXuE7_cwBM6N8yTz6VxjD0nQg");
      googleGeocoding.geocoding.getReverse(LatLon(widget.pos.latitude, widget.pos.longitude)).then((data) {
        setState(() {
          addressController.text = data.results[0].formattedAddress;
        });
      });
    });
    super.initState();
  }

  void _submitForm(BuildContext context) {
    if(widget.doc == null) {
      Firestore.instance.collection('users').document(widget.uid).setData({
        'name': name,
        'address': addressController.text,
        'location': widget.pos.data
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardPage()));
    } else {
      Firestore.instance.collection('users').document(widget.uid).updateData({
        'name': name,
        'address': addressController.text,
        'location': widget.pos.data
      });
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => DashboardPage()));
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
                        keyboardType: TextInputType.multiline,
                        controller: addressController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'आपला पत्ता',
                          labelText: 'पत्ता',
                        ))),
                RaisedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => LocationPickPage(doc: widget.doc, uid: widget.uid)));
                  },
                  icon: Icon(Icons.location_on),
                  label: Text("आपले घर नकाशावर पहा"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),

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
