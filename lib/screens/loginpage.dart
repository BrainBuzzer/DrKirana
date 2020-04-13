import 'package:dr_kirana/services/authservice.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  static final facebookAppEvents = FacebookAppEvents();

  String phoneNo, verificationId, smsCode;

  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: BluePainter(),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 0, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'डॉक्टर',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 60
                      )
                    ),
                    Text(
                      'किराणा',
                      style: TextStyle(
                        color: Colors.limeAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 60
                      )
                    )
                  ],
                )
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                child: Stack(
                  alignment: Alignment(1.1,0.0),
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'मोबाइल नंबर टाका',
                        prefixText: '+91',
                      ),
                      onChanged: (val) {
                        setState(() {
                          this.phoneNo = val;
                        });
                      }
                    ),
                    codeSent ? Container()
                    : FlatButton(
                        shape: new CircleBorder(),
                        color: Colors.blueAccent,

                        textColor: Colors.white,
                        child: Icon(
                          Icons.send,
                        ),
                        onPressed: () {
                          codeSent ? AuthService().signInWithOTP(smsCode, verificationId) : verifyPhone(phoneNo);
                        },
                      ),
                  ]
                )
              ),
              codeSent ? Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                child: PinPut(
                  actionButtonsEnabled: false,
                  inputDecoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    counterText: '',
                    contentPadding: EdgeInsets.only(left: 10, right: 10, top: 8.0, bottom: 8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3)
                    )
                  ),
                  fieldsCount: 6,
                  onSubmit: (String pin) {
                    codeSent ? AuthService().signInWithOTP(pin, verificationId) : verifyPhone(phoneNo);
                  },
                )
              ) : Container(),
              codeSent ? Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                child: RaisedButton(
                  color: Colors.white,
                  padding: EdgeInsets.all(15),
                  textTheme: ButtonTextTheme.primary,
                  textColor: Colors.black,
                  child: Center(child: Text('पुष्टी करा')),
                  onPressed: () {
                    codeSent ? AuthService().signInWithOTP(smsCode, verificationId) : verifyPhone(phoneNo);
                  },
                ),
              ) : Container(),
              Padding(
                padding: EdgeInsets.all(25.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "आपण दुकानदार आहात का? आत्ताच संपर्क करा.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                        ),
                      ),
                      RaisedButton.icon(
                          color: Colors.blue,
                          onPressed: _callNumber,
                          icon: Icon(Icons.call, color: Colors.white),
                          label: Text("संपर्क साधा", style: TextStyle(color: Colors.white))
                      )
                    ]
                  ),
                )
              )
            ]
          )
        ),
      )
    );
  }

  _callNumber() async {
    String url = "tel:+919637305012";
    facebookAppEvents.logEvent(name: "callHomeNumber");
    if(await canLaunch(url)) {
      launch(url);
    }
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

class BluePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Colors.blue.shade700;
    canvas.drawPath(mainBackground, paint);

    Path ovalPath = Path();
    // Start paint from 20% height to the left
    ovalPath.moveTo(0, height * 0.2);

    // paint a curve from current position to middle of the screen
    ovalPath.quadraticBezierTo(
        width * 0.45, height * 0.25, width * 0.51, height * 0.5);

    // Paint a curve from current position to bottom left of screen at width * 0.1
    ovalPath.quadraticBezierTo(width * 0.58, height * 0.8, width * 0.1, height);

    // draw remaining line to bottom left side
    ovalPath.lineTo(0, height);

    // Close line to reset it back
    ovalPath.close();

    paint.color = Colors.blue.shade600;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
