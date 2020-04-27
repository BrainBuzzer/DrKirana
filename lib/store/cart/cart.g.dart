// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Cart on _Cart, Store {
  Computed<int> _$numberOfItemsComputed;

  @override
  int get numberOfItems =>
      (_$numberOfItemsComputed ??= Computed<int>(() => super.numberOfItems))
          .value;

  final _$itemsAtom = Atom(name: '_Cart.items');

  @override
  ObservableMap<String, Map<dynamic, dynamic>> get items {
    _$itemsAtom.context.enforceReadPolicy(_$itemsAtom);
    _$itemsAtom.reportObserved();
    return super.items;
  }

  @override
  set items(ObservableMap<String, Map<dynamic, dynamic>> value) {
    _$itemsAtom.context.conditionallyRunInAction(() {
      super.items = value;
      _$itemsAtom.reportChanged();
    }, _$itemsAtom, name: '${_$itemsAtom.name}_set');
  }

  final _$_CartActionController = ActionController(name: '_Cart');

  @override
  void addOrEditItem(DocumentSnapshot product, String quantity) {
    final _$actionInfo = _$_CartActionController.startAction();
    try {
      return super.addOrEditItem(product, quantity);
    } finally {
      _$_CartActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeItem(DocumentSnapshot product) {
    final _$actionInfo = _$_CartActionController.startAction();
    try {
      return super.removeItem(product);
    } finally {
      _$_CartActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'items: ${items.toString()},numberOfItems: ${numberOfItems.toString()}';
    return '{$string}';
  }
}
