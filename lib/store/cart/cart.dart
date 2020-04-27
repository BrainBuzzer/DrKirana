import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

part 'cart.g.dart';

class Cart = _Cart with _$Cart;

abstract class _Cart with Store {
  @observable
  ObservableMap<String, Map> items = ObservableMap.of({});

  @computed
  int get numberOfItems => items.length;

  @action
  void addOrEditItem(DocumentSnapshot product, String quantity) {
    if (items.containsKey(product.documentID)) {
      items[product.documentID]['quantity'] = quantity;
    } else {
      var item = {"ref": product.documentID, "quantity": quantity};
      items.putIfAbsent(product.documentID, () => item);
    }
  }

  @action
  void removeItem(DocumentSnapshot product) {
    items.removeWhere((key, _) => key == product.documentID);
  }
}
