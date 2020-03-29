import 'package:dr_kirana/services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String phoneNo, verificationId, smsCode;

  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Dr Kirana")
      ),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(hintText: 'Enter Phone Number'),
                onChanged: (val) {
                  setState(() {
                    this.phoneNo = val;
                  });
                }
              ),
            ),
            codeSent ? Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(hintText: 'Enter OTP'),
                  onChanged: (val) {
                    setState(() {
                      this.smsCode = val;
                    });
                  }
              ),
            ) : Container(),
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: RaisedButton(
                child: Center(child: codeSent ? Text('Login') : Text('Verify')),
                onPressed: () {
                  codeSent ? AuthService().signInWithOTP(smsCode, verificationId) : verifyPhone(phoneNo);
                },
              ),
            )
          ]
        )
      ),
    );
  }
  
  Future<void> verifyPhone(phoneNo) async {

    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed failed = (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91' + phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: failed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout
    );
  }
}
