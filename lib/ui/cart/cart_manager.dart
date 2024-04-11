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

  Future<void> addItem(Product product, int quantity) async {
  // Tìm kiếm trong _items xem có sản phẩm có cùng id với product không
  String? existingCartItemKey;
  _items.forEach((key, value) {
    if (value.id == product.id) {
      existingCartItemKey = key;
    }
  });

  // Nếu tìm thấy sản phẩm trong giỏ hàng
  if (existingCartItemKey != null) {
    // Cập nhật số lượng của sản phẩm đã tồn tại
    final existingCartItem = _items[existingCartItemKey]!;
    final updatedQuantity = existingCartItem.quantity + quantity;
    final updatedCartItem = existingCartItem.copyWith(quantity: updatedQuantity);

    await _cartService.updateCart(updatedCartItem);
  } else {
    // Nếu sản phẩm chưa có trong giỏ hàng, thêm mới sản phẩm
    final newCartItem = CartItem(
      id: product.id ?? "",
      title: product.title,
      imageUrl: product.imageUrl,
      quantity: quantity,
      price: product.price,
    );

    await _cartService.addCart(newCartItem);
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



  // void removeItem(String productId) {
  //   if(!_items.containsKey(productId)) {
  //     return ;
  //   }
  //   if(_items[productId]?.quantity as num > 1){
  //     _items.update(
  //       productId,
  //       (existingCartItem) => existingCartItem.copyWith(
  //         quantity: existingCartItem.quantity - 1,
  //       ),
  //     );
  //   } else {
  //     _items.remove(productId);
  //   }
  //   notifyListeners();
  // }

void removeItem(String cartItemId) async {
  final bool deleted = await _cartService.deleteCart(cartItemId);
  if (deleted) {
    _items.remove(cartItemId);
    notifyListeners();
  } else {
    print('Failed to delete cart item');
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