import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatelessWidget {
  static final facebookAppEvents = FacebookAppEvents();
  @override
  Widget build(BuildContext context) {
    facebookAppEvents.logEvent(name: "access_help_page");
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
              "संपर्क साधा",
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
                  "जर आपणास आपले दुकान एप वरती नोंदणी करवायचे असेल तर कृपया खालील बटन वर दाबून संपर्क साधावा.",
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),
              ),
            )
          ),
          RaisedButton(
            onPressed: _email,
            child: new Text('ई-मेल'),
          ),
          RaisedButton.icon(
            onPressed: _call,
            icon: Icon(Icons.call),
            label: new Text('फोन कॉल')
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
