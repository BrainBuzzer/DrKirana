import 'package:flutter/material.dart';

class OrderedItemList extends StatefulWidget {
  final orderList;

  OrderedItemList({Key key, this.orderList}) : super(key: key);

  @override
  _OrderedItemListState createState() => _OrderedItemListState();
}

class _OrderedItemListState extends State<OrderedItemList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text("Order List"),
        ),
        body: Flex(direction: Axis.vertical, children: <Widget>[
          Flexible(
            flex: 10,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(widget.orderList['items'][index]['name']),
                  subtitle: Text(widget.orderList['items'][index]['quantity']),
                  trailing:
                      Text("₹${widget.orderList['items'][index]['price']}"),
                );
              },
              itemCount: widget.orderList['items'].length,
            ),
          ),
          Flexible(
            flex: 1,
            child: Card(
              elevation: 4,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Total: ₹${widget.orderList['total']}",
                        style: Theme.of(context).textTheme.title),
                  ),
                ),
              ),
            ),
          )
        ]));
  }
}
