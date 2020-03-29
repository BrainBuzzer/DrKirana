import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_kirana/screens/order_details.dart';
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
    AuthService().getCurrentUID().then((user) {
      setState(() {
        uid = user.uid;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Previous Orders'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('orders').where('uid', isEqualTo: uid).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return const Text('loadin...');
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemExtent: 80,
            itemBuilder: (context, index) {
              return ListTile(
                title: new Text(
                  (index+1).toString(),
                  style: Theme.of(context).textTheme.headline,
                ),
                subtitle: new Text(
                  timeago.format(snapshot.data.documents[index]['time_order_placed'].toDate(), locale: 'hi')
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailPage(order: snapshot.data.documents[index])
                    )
                  );
                }
              );
            }
          );
        }
      )
    );
  }
}
