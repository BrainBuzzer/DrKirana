import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Dr Kirana")
      ),
      body: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Contact Us",
              style: TextStyle(
                fontSize: 50
              ),
            )
          ),
          RaisedButton(
            onPressed: _email,
            child: new Text('Email'),
          ),
          RaisedButton(
            onPressed: _call,
            child: new Text('Call')
          )
        ],
      )
    );
  }

  _email() async {
    const url = 'mailto:aditya@hyperlog.io?subject=Hello';
    if(await canLaunch(url)) {
      await(launch(url));
    }
  }

  _call() async {
    const url = 'tel:+919130460885';
    if(await canLaunch(url)) {
      await(launch(url));
    }
  }
}
