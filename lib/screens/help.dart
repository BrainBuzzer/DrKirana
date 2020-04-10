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
          Center(
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "If you want to get your shop registered on this app, please click on the call button. We'd love to have you onboard.",
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),
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
    const url = 'tel:+919637305012';
    if(await canLaunch(url)) {
      await(launch(url));
    }
  }
}
