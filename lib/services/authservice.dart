import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_kirana/screens/user/dashboard.dart';
import 'package:dr_kirana/screens/loginpage.dart';
import 'package:dr_kirana/screens/user/location_pick.dart';
import 'package:dr_kirana/screens/user/user_profile_edit.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final facebookAppEvents = FacebookAppEvents();
  static final FirebaseAnalytics analytics = FirebaseAnalytics();
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if(snapshot.hasData) {
          return StreamBuilder(
            stream: Firestore.instance.collection('users').document(snapshot.data.uid).snapshots(),
            builder: (context, userSnapshot) {
              if(!userSnapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator()
                );
              }
              if(userSnapshot.data.exists) {
                facebookAppEvents.logEvent(name: "user_signed_in");
                analytics.logLogin();
                return DashboardPage();
              } else {
                facebookAppEvents.logEvent(name: "user_signed_up");
                analytics.logSignUp(signUpMethod: "phone_number");
                return LocationPickPage(uid: snapshot.data.uid);
              }
            }
          );
        }
        else {
          return LoginPage();
        }
      }
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  signIn(AuthCredential authCredential) {
    FirebaseAuth.instance.signInWithCredential(authCredential);
  }

  signInWithOTP(smsCode, verId) {
    AuthCredential authCredential = PhoneAuthProvider.getCredential(verificationId: verId, smsCode: smsCode);
    signIn(authCredential);
  }
}