import 'package:dr_kirana/screens/listcapture.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Dr Kirana")
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            Card(
              child: new InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListCapturePage(type: "किराणा")));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Center(
                    child: Text(
                      "किराणा",
                      style: TextStyle(fontSize: 50)
                    )
                  ),
                )
              )
            ),
            Card(
              child: new InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListCapturePage(type: "भाजीपाला")));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Center(
                    child: Text(
                      "भाजीपाला",
                      style: TextStyle(fontSize: 50)
                    )
                  ),
                )
              )
            )
          ],
        )
      )
    );
  }
}
