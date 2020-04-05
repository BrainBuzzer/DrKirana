import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_kirana/screens/user/user_profile_edit.dart';
import 'package:dr_kirana/services/authservice.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService().getCurrentUID(),
        builder: (context, uid) {
          return StreamBuilder(
              stream: Firestore.instance.collection('users').document(uid.data).snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if(!snapshot.data.exists) {
                  return UserProfileEditPage(uid: uid.data);
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileEditPage(doc: snapshot.data, uid: uid.data)));
                        },
                        label: Text("Edit Profile Info"),
                        icon: Icon(Icons.edit)
                      )
                    ],
                  ),
                );
              }
          );
        }
    );
  }
}
