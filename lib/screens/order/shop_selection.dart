import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_kirana/screens/order/listcapture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShopSelectionPage extends StatefulWidget {
  final String type;
  ShopSelectionPage({Key key, this.type}) : super(key: key);

  @override
  _ShopSelectionPageState createState() => _ShopSelectionPageState();
}

class _ShopSelectionPageState extends State<ShopSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("दुकान निवड करा")
      ),
      body: new StreamBuilder(
        stream: Firestore.instance.collection('shops').where('city', isEqualTo: "Latur").where('type', arrayContains: widget.type).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData)
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            )
          );
          return GridView.builder(
            itemCount: snapshot.data.documents.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(5),
                child: Card(
                  elevation: 5,
                  child: new InkWell(
                    child: Stack(
                      children: <Widget>[
                        Image(
                          image: NetworkImage(snapshot.data.documents[index]['logo']),
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
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [Colors.black, Colors.black54, Colors.transparent]
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Text(
                                    snapshot.data.documents[index]['name'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Text(
                                      snapshot.data.documents[index]['address'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      )
                                  ),
                                ),

                              ]
                          ),
                        ),
                      ]
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListCapturePage(type: widget.type, shop: snapshot.data.documents[index].documentID, note: snapshot.data.documents[index]["note"])
                        )
                      );
                    }
                  )
                )
              );
            }
          );
        }
      )
    );
  }
}
