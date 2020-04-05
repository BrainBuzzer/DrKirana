import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_kirana/screens/order/order_details.dart';
import 'package:dr_kirana/services/authservice.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class OrdersListPage extends StatefulWidget {
  @override
  _OrdersListPageState createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> {
  String uid;

  void initState() {
    AuthService().getCurrentUID().then((id) {
      setState(() {
        uid = id;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(uid == null)
      return Center(
        child: CircularProgressIndicator()
      );
    return StreamBuilder(
        stream: Firestore.instance.collection('orders').where('uid', isEqualTo: uid).orderBy('time_order_placed', descending: true).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              )
            );
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemExtent: 80,
            itemBuilder: (context, index) {
              return ListTile(
                title: new Text(
                  snapshot.data.documents[index]['type'] + " " + (index+1).toString(),
                  style: Theme.of(context).textTheme.headline,
                ),
                subtitle: new Text(
                  timeago.format(snapshot.data.documents[index]['time_order_placed'].toDate())
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailPage(orderId: snapshot.data.documents[index].documentID)
                    )
                  );
                }
              );
            }
          );
        }
    );
  }
}
