import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

part 'cart.g.dart';

class Cart = _Cart with _$Cart;

abstract class _Cart with Store {
  @observable
  List<Map> items = [];

  @action
  void addItemToCart(DocumentSnapshot product, int quantity) {
    print(quantity);
    var item = {
      "ref": product.documentID,
      "price": product.data['price'],
      "quantity": quantity
    };
    items.add(item);
  }

  @action
  void removeItemFromCart(DocumentSnapshot product) {
    items.removeWhere((item) => item["ref"] == product.documentID);
  }
}
