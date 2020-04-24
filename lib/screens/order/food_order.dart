import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FoodOrderPage extends StatefulWidget {
  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  List<Map> section = [
    {"name": "Tea and Coffee", "id": "tea"},
    {"name": "Farsan", "id": "farsan"},
    {"name": "Snacks", "id": "snacks"},
    {"name": "Namkeen", "id": "namkeen"},
    {"name": "Chocolates", "id": "chocolates"},
    {"name": "Instant Energy Drinks", "id": "energy_drinks"},
    {"name": "Syrups", "id": "syrups"},
    {"name": "Breakfast Items", "id": "breakfast"},
    {"name": "Biscuits", "id": "biscuits"},
    {"name": "Sauces and Spreads", "id": "sauces"},
    {"name": "Noodles and Pasta", "id": "noodles"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text("Food Items"),
        ),
        body: new Container(
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection("shops")
                    .document("v7W7d4ZmvWZYpx1TxNkH")
                    .collection("menu")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                                "Brought in association with Chaapsi Foods")),
                      ),
                      Divider(),
                      Expanded(
                        child: SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: section.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _buildSections(
                                  section[index], snapshot.data.documents);
                            },
                          ),
                        ),
                      )
                    ],
                  );
                })));
  }

  Widget _buildSections(Map section, List<DocumentSnapshot> data) {
    var listItems = data.where((item) => item.data['type'] == section['id']);
    return ExpansionTile(
      title: Text(section['name']),
      children: listItems
          .map((item) => new ListTile(
                title: Text(item.data['name']),
                subtitle: Text("₹" + item.data['price']),
              ))
          .toList(),
    );
  }
}
