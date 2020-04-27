import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

part 'cart.g.dart';

class Cart = _Cart with _$Cart;

abstract class _Cart with Store {
  @observable
  ObservableMap<String, Map> items = ObservableMap.of({});

  @observable
  String shop;

  @action
  setShop(rec) => shop = rec;

  @computed
  int get numberOfItems => items.length;

  @observable
  int totalPrice = 0;

  @action
  void addOrEditItem(
      DocumentSnapshot product, String quantity, String recShop) {
    int qty = int.parse(quantity);
    int price = int.parse(product.data['price']) * qty;
    if (shop == recShop) {
      if (items.containsKey(product.documentID)) {
        items[product.documentID]['quantity'] = qty;
        items[product.documentID]['price'] = price;
        getTotalPrice();
      } else {
        var item = {"product": product, "quantity": qty, "price": price};
        items.putIfAbsent(product.documentID, () => item);
        getTotalPrice();
      }
    } else {
      emptyCart();
      var item = {"product": product, "quantity": qty, "price": price};
      items.putIfAbsent(product.documentID, () => item);
      getTotalPrice();
    }
  }

  @action
  void removeItem(DocumentSnapshot product) {
    items.removeWhere((key, _) => key == product.documentID);
  }

  @action
  void emptyCart() {
    items = ObservableMap.of({});
    totalPrice = 0;
  }

  void getTotalPrice() {
    totalPrice = 0;
    items.forEach((key, value) {
      totalPrice += value['price'];
    });
  }
}
