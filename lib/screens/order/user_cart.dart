import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_kirana/store/cart/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class UserCart extends StatefulWidget {
  final DocumentSnapshot shop;

  UserCart({Key key, @required this.shop}) : super(key: key);

  @override
  _UserCartState createState() => _UserCartState();
}

class _UserCartState extends State<UserCart> {
  TextEditingController quantityController;
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    quantityController = TextEditingController();
    super.initState();
  }

  showQuantityEditDialog(BuildContext context, DocumentSnapshot doc) {
    final cart = Provider.of<Cart>(context, listen: false);
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        quantityController.clear();
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("अॅड करा"),
      onPressed: () {
        if (_key.currentState.validate()) {
          cart.addOrEditItem(doc, quantityController.text);
          Navigator.pop(context);
          quantityController.clear();
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Form(
        key: _key,
        child: TextFormField(
          controller: quantityController,
          autovalidate: true,
          validator: (val) {
            if (val.isEmpty) {
              return "कृपया आपल्याला हवे असलेले प्रमाण टाका";
            } else if (int.parse(val) <= 0) {
              return "1 किवा त्यापेक्षा अधिक वस्तु मागणी करा";
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(90),
            ),
            fillColor: Colors.white,
            filled: true,
            labelText: "प्रमाण टाका",
            hintText: 'प्रमाण टाका',
            suffixText: doc.data['size']['unit'],
          ),
          keyboardType: TextInputType.number,
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
        appBar: new AppBar(title: Text("Your Cart")),
        body: Observer(
          builder: (_) {
            return Flex(direction: Axis.vertical, children: <Widget>[
              Flexible(
                flex: 1,
                child: Card(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Observer(
                          builder: (_) => Text("Total: ₹${cart.totalPrice}",
                              style: Theme.of(context).textTheme.title),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 10,
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key = cart.items.keys.elementAt(index);
                    return Dismissible(
                      background: Container(color: Colors.red),
                      onDismissed: (direction) {
                        cart.removeItem(cart.items[key]['product']);
                      },
                      key: Key(key),
                      child: new ListTile(
                          title: Text(cart.items[key]['product']['name']),
                          subtitle: Observer(
                            builder: (_) => Text(
                                "${cart.items[key]['quantity']} ${cart.items[key]['product']['size']['unit']}"),
                          ),
                          trailing: Observer(
                              builder: (_) =>
                                  Text("₹${cart.items[key]['price']}")),
                          onTap: () {
                            quantityController.text =
                                cart.items[key]['quantity'].toString();
                            showQuantityEditDialog(
                                context, cart.items[key]['product']);
                          }),
                    );
                  },
                ),
              ),
              Flexible(
                  flex: 1,
                  child: RaisedButton.icon(
                      color: Colors.blue,
                      icon: Icon(Icons.shopping_cart, color: Colors.white),
                      onPressed: () {},
                      label: Text(
                        "ऑर्डर करा",
                        style: TextStyle(color: Colors.white),
                      )))
            ]);
          },
        ));
  }
}