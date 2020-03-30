import 'package:dr_kirana/screens/listcapture.dart';
import 'package:dr_kirana/screens/orders_list.dart';
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
            Flexible(
              child: Card(
                child: new InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ListCapturePage(type: "किराणा")));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Center(
                      child: Text(
                        "किराणा",
                        style: TextStyle(fontSize: 50)
                      )
                    ),
                  )
                )
              ),
            ),
            Flexible(
              child: Card(
                child: new InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ListCapturePage(type: "भाजीपाला")));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Center(
                      child: Text(
                        "भाजीपाला",
                        style: TextStyle(fontSize: 50)
                      )
                    ),
                  )
                )
              ),
            ),
            Flexible(
              child: Card(
                child: new InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersListPage()));
                  },
                  child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Center(
                    child: Text(
                      "केलेल्या ऑर्डर्स",
                      style: TextStyle(fontSize: 50)
                    )
                  ),
                  )
                )
              )
            ),
          ],
        )
      )
    );
  }
}
