import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_kirana/screens/order/image_view.dart';
import 'package:dr_kirana/screens/order/ordered_item_list.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;
  OrderDetailPage({Key key, this.orderId}) : super(key: key);
  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(title: new Text("Order Details")),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('orders')
                .document(widget.orderId)
                .snapshots(),
            builder: (context, orderSnapshot) {
              if (!orderSnapshot.hasData) {
                return Container(
                    child: Center(child: CircularProgressIndicator()));
              }
              return new StreamBuilder(
                  stream: Firestore.instance
                      .collection('shops')
                      .document(orderSnapshot.data['shop'])
                      .snapshots(),
                  builder: (context, shopSnapshot) {
                    if (shopSnapshot.data == null) {
                      return Container(
                          child: Center(child: CircularProgressIndicator()));
                    }
                    return Column(
                      children: <Widget>[
                        _conditionalWidget(orderSnapshot.data['status']),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Card(
                            elevation: 3,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(shopSnapshot.data['name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  subtitle: Text(shopSnapshot.data['address']),
                                  leading: Icon(
                                    Icons.business,
                                    color: Colors.blue[500],
                                  ),
                                ),
                                Divider(),
                                ListTile(
                                    title: Text(
                                      "ऑर्डरची यादी",
                                    ),
                                    leading: Icon(Icons.image,
                                        color: Colors.blue[500]),
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        if (orderSnapshot.data['cat'] ==
                                            'list') {
                                          return OrderedItemList(
                                              orderList:
                                                  orderSnapshot.data['order']);
                                        }
                                        return ImageView(
                                            imageLocation:
                                                orderSnapshot.data['image']);
                                      }));
                                    }),
                                ListTile(
                                  title:
                                      Text(shopSnapshot.data['phone_number']),
                                  leading: Icon(
                                    Icons.contact_phone,
                                    color: Colors.blue[500],
                                  ),
                                  onTap: () {
                                    _callUser(
                                        orderSnapshot.data['phone_number']);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (orderSnapshot.data['status'] == 'completed' ||
                            orderSnapshot.data['status'] == 'out_for_delivery')
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 3,
                              color: Colors.blue,
                              child: ListTile(
                                  title: Text("View Receipt",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white)),
                                  leading:
                                      Icon(Icons.receipt, color: Colors.white),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ImageView(
                                                imageLocation: orderSnapshot
                                                    .data['receipt'])));
                                  }),
                            ),
                          ),
                        if (orderSnapshot.data['status'] == 'placed')
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: Card(
                                elevation: 3,
                                color: Colors.red,
                                child: ListTile(
                                  title: Text("ऑर्डर रद्द करा",
                                      style: TextStyle(color: Colors.white)),
                                  leading: Icon(Icons.shopping_cart,
                                      color: Colors.white),
                                  onTap: () {
                                    _cancelOrder(orderSnapshot.data);
                                  },
                                ),
                              )),
                      ],
                    );
                  });
            }));
  }

  Widget _conditionalWidget(String status) {
    switch (status) {
      case 'placed':
        return Padding(
            padding: EdgeInsets.all(8),
            child: Card(
              elevation: 3,
              color: Colors.blue,
              child: ListTile(
                  title: Text("ऑर्डर पाठवली",
                      style: TextStyle(color: Colors.white)),
                  leading: Icon(Icons.shopping_cart, color: Colors.white)),
            ));
        break;
      case 'processing':
        return Padding(
            padding: EdgeInsets.all(8),
            child: Card(
              elevation: 3,
              color: Colors.lightGreen,
              child: ListTile(
                  title: Text("दुकानदार आपली ऑर्डर तयार करत आहे.",
                      style: TextStyle(color: Colors.white)),
                  leading: Icon(Icons.timer, color: Colors.white)),
            ));
        break;
      case 'out_for_delivery':
        return Padding(
            padding: EdgeInsets.all(8),
            child: Card(
              elevation: 3,
              color: Colors.green,
              child: ListTile(
                  title: Text("आपली ऑर्डर डिलीवेरी साठी बाहेर पडलेली आहे.",
                      style: TextStyle(color: Colors.white)),
                  leading: Icon(Icons.directions_walk, color: Colors.white)),
            ));
        break;
      case 'cancelled':
        return Padding(
            padding: EdgeInsets.all(8),
            child: Card(
              elevation: 3,
              color: Colors.red,
              child: ListTile(
                  title: Text("आपण आपली ऑर्डर रद्द केली आहे.",
                      style: TextStyle(color: Colors.white)),
                  leading: Icon(Icons.cancel, color: Colors.white)),
            ));
        break;
      case 'declined':
        return Padding(
            padding: EdgeInsets.all(8),
            child: Card(
              elevation: 3,
              color: Colors.red,
              child: ListTile(
                  title: Text("दुकानदारांनी आपल्या ऑर्डर साठी नकार दिला.",
                      style: TextStyle(color: Colors.white)),
                  leading: Icon(Icons.cancel, color: Colors.white)),
            ));
        break;
      case 'completed':
        return Padding(
            padding: EdgeInsets.all(8),
            child: Card(
              elevation: 3,
              color: Colors.green,
              child: ListTile(
                  title: Text("तुमची ऑर्डर यशस्वीरीत्या तुमच्यापर्यंत पोहचवली",
                      style: TextStyle(color: Colors.white)),
                  leading:
                      Icon(Icons.check_circle_outline, color: Colors.white)),
            ));
        break;
      default:
        return Padding(
            padding: EdgeInsets.all(8),
            child: Card(
                elevation: 3,
                child: ListTile(
                  title: Text("Something went wrong."),
                )));
        break;
    }
  }

  _callUser(phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  void _cancelOrder(DocumentSnapshot order) async {
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction.get(order.reference);
      await transaction.update(freshSnap.reference, {'status': 'cancelled'});
    });
  }
}
