import 'package:dr_kirana/screens/help.dart';
import 'package:dr_kirana/screens/order/shop_selection.dart';
import 'package:dr_kirana/screens/order/orders_list.dart';
import 'package:dr_kirana/screens/user/user_profile.dart';
import 'package:flutter/cupertino.dart';
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
        title: new Text(
          "Dr Kirana",
          style: TextStyle(
            color: Colors.black,
          )
        ),
        backgroundColor: Colors.white,
        elevation: 10,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersListPage()));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage()));
            },
          )
        ],
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            Flexible(
              flex: 3,
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ShopSelectionPage(type: "किराणा")));
                  },
                  child: Stack(
                      children: <Widget>[
                        Image(
                          image: AssetImage('assets/kirana.jpg'),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                        ),
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.8,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    end: Alignment.centerLeft,
                                    begin: Alignment.centerRight,
                                    colors: [Colors.black87, Colors.black54, Colors.transparent]
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0,0,50,0),
                                    child: Text(
                                        "किराणा",
                                        style: TextStyle(
                                          fontSize: 50,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )
                                    )
                                )
                              ]
                          ),
                        ),
                      ]
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 10,
                margin: EdgeInsets.all(10),
              ),
            ),
            Flexible(
              flex: 3,
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ShopSelectionPage(type: "भाजीपाला")));
                  },
                  child: Stack(
                      children: <Widget>[
                        Image(
                          image: AssetImage('assets/bhajipala.jpg'),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                        ),
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.8,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [Colors.black87, Colors.black54, Colors.transparent]
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.fromLTRB(50,0,0,0),
                                    child: Text(
                                        "भाजीपाला",
                                        style: TextStyle(
                                          fontSize: 50,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )
                                    )
                                )
                              ]
                          ),
                        ),
                      ]
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 10,
                margin: EdgeInsets.all(10),
              ),
            ),
            Flexible(
              flex: 3,
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ShopSelectionPage(type: "non_veg")));
                  },
                  child: Stack(
                      children: <Widget>[
                        Image(
                          image: AssetImage('assets/meat.jpg'),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                        ),
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.5,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                    child: Text(
                                        "चिकन/मटण",
                                        style: TextStyle(
                                          fontSize: 50,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )
                                    )
                                )
                              ]
                          ),
                        ),
                      ]
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 10,
                margin: EdgeInsets.all(10),
              ),
            ),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HelpPage()));
        },
        child: Icon(
          Icons.help_outline
        ),
      ),
    );
  }
}
