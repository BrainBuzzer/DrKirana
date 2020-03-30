import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_kirana/services/firebasestorageservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatefulWidget {
  DocumentSnapshot order;
  OrderDetailPage({Key key, this.order}): super(key: key);
  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            title: new Text("ऑर्डर माहिती")
        ),
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: FutureBuilder(
                    future: _getImage(context, widget.order['image']),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.done)
                        return Container(
                          height: MediaQuery.of(context).size.height/1.25,
                          width: MediaQuery.of(context).size.width/1.25,
                          child: snapshot.data,
                        );

                      if(snapshot.connectionState == ConnectionState.waiting)
                        return CircularProgressIndicator();

                      return Container();
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      Container(
                        height: 50,
                        color: Colors.amber[600],
                        child: Center(child: Text(widget.order['type'])),
                      ),
                      Container(
                        height: 50,
                        color: Colors.amber[500],
                        child: Center(child: Text(widget.order['time_order_placed'].toDate().toString())),
                      ),
                      StreamBuilder(
                        stream: Firestore.instance.collection('shops').document(widget.order['shop']).snapshots(),
                        builder: (context, snapshot) {
                          print(snapshot);
                          if(!snapshot.hasData)
                            return new Text("Loading Shop Details");

                          return new Container(
                              height: 50,
                              color: Colors.amber[400],
                              child: Center(child: Text(snapshot.data['name']))
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            )
        )
    );
  }

  Future<Widget> _getImage(BuildContext context, String image) async {
    CachedNetworkImage m;
    await FireStorageService.loadImage(context, image).then((downloadUrl) {
      m = CachedNetworkImage(
        imageUrl: downloadUrl.toString(),
        placeholder: (context, url) => Container(
          child: Center(
            child: CircularProgressIndicator(),
          )
        ),
      );
    });
    return m;
  }
}
