import 'package:dr_kirana/screens/dashboard.dart';
import 'package:dr_kirana/screens/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if(snapshot.hasData) {
          return DashboardPage();
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

  Future<FirebaseUser> getCurrentUID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }
}