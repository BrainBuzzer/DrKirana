import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_kirana/screens/user/location_pick.dart';
import 'package:dr_kirana/screens/user/user_profile_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context, listen: true);
    if(user == null) {
      return Container(
        child: CircularProgressIndicator(),
      );
    }
    return StreamBuilder(
          stream: Firestore.instance.collection('users').document(user.uid).snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if(!snapshot.data.exists) {
              return UserProfileEditPage(uid: user.uid);
            }

            return Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    snapshot.data['name'],
                    style: Theme.of(context).textTheme.title
                  ),
                  Text(
                    snapshot.data["address"],
                    style: Theme.of(context).textTheme.subhead
                  ),
                  RaisedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LocationPickPage(doc: snapshot.data, uid: user.uid)));
                    },
                    label: Text("माहिती बदल करा"),
                    icon: Icon(Icons.edit)
                  )
                ],
              ),
            );
          }
      );
  }
}
