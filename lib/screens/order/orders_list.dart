import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_kirana/screens/order/order_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class OrdersListPage extends StatefulWidget {
  @override
  _OrdersListPageState createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context, listen: true);

    return StreamBuilder(
        stream: Firestore.instance.collection('orders').where('uid', isEqualTo: user.uid).orderBy('time_order_placed', descending: true).snapshots(),
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
                trailing: conditionalWidget(snapshot.data.documents[index]['status']),
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

  Widget conditionalWidget(String status) {
    switch(status) {
      case 'placed': {
        return Container(
            padding: EdgeInsets.all(10),
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlue
            ),
            child: Icon(Icons.timer, color: Colors.white)
        );
      }
      break;
      case 'processing': {
        return Container(
            padding: EdgeInsets.all(10),
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow
            ),
            child: Icon(Icons.departure_board)
        );
      }
      break;
      case 'out_for_delivery': {
        return Container(
            padding: EdgeInsets.all(10),
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.greenAccent
            ),
            child: Icon(Icons.directions_walk)
        );
      }
      break;
      case 'declined': {
        return Container(
            padding: EdgeInsets.all(10),
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red
            ),
            child: Icon(Icons.clear, color: Colors.white)
        );
      }
      case 'cancelled': {
        return Container(
            padding: EdgeInsets.all(10),
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange
            ),
            child: Icon(Icons.event_busy, color: Colors.white)
        );
      }
      break;
      case 'completed': {
        return Container(
            padding: EdgeInsets.all(10),
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green
            ),
            child: Icon(Icons.check_circle_outline, color: Colors.white,)
        );
      }
      break;
      default: {
        return Container(
            padding: EdgeInsets.all(10),
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent
            ),
            child: Icon(Icons.warning)
        );
      }
      break;
    }
  }
}
