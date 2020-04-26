import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_kirana/screens/order/shop_order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';

class ShopSelectionPage extends StatefulWidget {
  final String type;
  ShopSelectionPage({Key key, this.type}) : super(key: key);

  @override
  _ShopSelectionPageState createState() => _ShopSelectionPageState();
}

class _ShopSelectionPageState extends State<ShopSelectionPage> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context, listen: true);

    if (user == null) {
      return Container(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
        appBar: new AppBar(title: Text("दुकान निवड करा")),
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .document(user.uid)
              .snapshots(),
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData)
              return Container(
                  child: Center(
                child: CircularProgressIndicator(),
              ));
            return StreamBuilder(
                stream: listShops(userSnapshot),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Container(
                        child: Center(
                      child: CircularProgressIndicator(),
                    ));
                  return GridView.builder(
                      itemCount: snapshot.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.all(5),
                            child: Card(
                                elevation: 5,
                                child: new InkWell(
                                    child: Stack(children: <Widget>[
                                      Image(
                                        image: NetworkImage(snapshot.data[index]
                                                ['logo'] ??
                                            "https://lh3.googleusercontent.com/iCM0YSo2WRcOJDuq-oi6zB6ElFTJGL1kxbZsB9x6t3nQ2febwMSvVjh7c6N4JJJaZQ=s180"),
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                                  colors: [
                                                    Colors.black,
                                                    Colors.black54,
                                                    Colors.transparent
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Text(
                                                    snapshot.data[index]
                                                        ['name'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Text(
                                                    snapshot.data[index]
                                                        ['address'],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white70,
                                                    )),
                                              ),
                                            ]),
                                      ),
                                    ]),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ShopOrderPage(
                                                      type: widget.type,
                                                      shop: snapshot
                                                          .data[index])));
                                    })));
                      });
                });
          },
        ));
  }

  Stream<List<DocumentSnapshot>> listShops(AsyncSnapshot snapshot) {
    Geoflutterfire geo = Geoflutterfire();
    GeoFirePoint center = geo.point(
        latitude: snapshot.data['location']['geopoint'].latitude,
        longitude: snapshot.data['location']['geopoint'].longitude);
    var collectionReference = Firestore.instance
        .collection('shops')
        .where('type', arrayContains: widget.type);

    double radius = 3;
    String field = 'location';

    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: field);
    return stream;
  }
}
