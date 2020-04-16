import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_kirana/screens/user/user_profile_edit.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationPickPage extends StatefulWidget {
  final DocumentSnapshot doc;
  final String uid;

  LocationPickPage({Key key, this.doc, @required this.uid}) : super(key: key);

  @override
  _LocationPickPageState createState() => _LocationPickPageState();
}

class _LocationPickPageState extends State<LocationPickPage> {
  GoogleMapController mapController;

  Location location = new Location();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(18.39, 76.56),
            zoom: 15
          ),
          onMapCreated: _onMapCreated,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          compassEnabled: true,
          mapType: MapType.normal,
        ),
        Align(
          alignment: Alignment.center,
          child: Image(
            height: 50,
            image: AssetImage("assets/marker_icon.png"),
            alignment: Alignment.center,
          ),
        ),
        Positioned(
          child: RaisedButton(
            child: new Text("ही जागा निवडा", style: TextStyle(
              fontSize: 20
            ),),
            padding: EdgeInsets.all(30),
            color: Colors.green,
            textColor: Colors.white,
            onPressed: _sendToNextScreen,
          ),
          bottom: 0,
          width: MediaQuery.of(context).size.width,
        ),
      ],
    );
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      _animateToUser();
    });
  }

  _animateToUser() async {
    var pos = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 17
      )
    ));
  }

  _sendToNextScreen() async {
    Geoflutterfire geo = Geoflutterfire();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double middleX = screenWidth / 2;
    double middleY = screenHeight / 2;

    ScreenCoordinate screenCoordinate = ScreenCoordinate(x: middleX.round(), y: middleY.round());

    LatLng selectedLocation = await mapController.getLatLng(screenCoordinate);
    GeoFirePoint pos = geo.point(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude);
    Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileEditPage(doc: widget.doc, uid: widget.uid, pos: pos)));
  }
}
