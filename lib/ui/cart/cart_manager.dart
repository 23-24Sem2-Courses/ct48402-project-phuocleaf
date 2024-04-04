import 'package:flutter/foundation.dart';

import '../../models/auth_token.dart';
import '../../models/cart_item.dart';

import '../../models/product.dart';
import '../../services/carts_service.dart';
 
class CartManager with ChangeNotifier {
  Map<String, CartItem> _items = {};

   final CartsService _cartService;

  CartManager([AuthToken? authToken])
    : _cartService = CartsService(authToken);
    
      
  set authToken(AuthToken? authToken){
    _cartService.authToken = authToken;
  }

  Future<void> fetchCarts() async {
    _items = (await _cartService.fetchCarts()) as Map<String, CartItem>;
    notifyListeners();
  }

  Future<void> addItem(Product product,int quantity) async {
    var k=null;
    _items.forEach((i, value) async { 
      if(_items[k]!.id == product.id){
        k = i;
      }
    });
    if(k != null){
        CartItem cartItem = CartItem(
          id: _items[k]!.id, 
          title: _items[k]!.title, 
          imageUrl: _items[k]!.imageUrl, 
          quantity: _items[k]!.quantity + quantity, 
          price: _items[k]!.price);

        await _cartService.updateCart(cartItem);
     
      }else{
         CartItem newItem = CartItem(
          id: product.id ?? "",
          title: product.title, 
          imageUrl: product.imageUrl, 
          quantity: quantity, 
          price: product.price
        );
        final newCartItem = await _cartService.addCart(newItem);
   
      }
  }
  int get productCount {
    return _items.length;
  }

  List<CartItem> get products {
    return _items.values.toList();
  }

  Iterable<MapEntry<String, CartItem>> get productEntries {
    return {... _items}.entries;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) { 
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }



  void removeItem(String productId) {
    if(!_items.containsKey(productId)) {
      return ;
    }
    if(_items[productId]?.quantity as num > 1){
      _items.update(
        productId,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearAllItem() {
    _items = {};
    notifyListeners();
  }
}