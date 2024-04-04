import 'package:flutter/foundation.dart';

import '../../models/auth_token.dart';
import '../../models/cart_item.dart';
import '../../models/order_item.dart';
import '../../services/orders_service.dart';


class OrdersManager with ChangeNotifier {
  List<OrderItem> _orders = [];

  final OrdersService _ordersService;

   OrdersManager([AuthToken? authToken])
      :_ordersService = OrdersService(authToken);
    
    set authToken(AuthToken? authToken){
      _ordersService.authToken = authToken;
    }
  
   int get orderCount {
    return _orders.length;
  }

  List<OrderItem> get orders {
    return [ ... _orders];
    } 
  Future<void> fetchOrders() async {
    _orders = await _ordersService.fetchOrders();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> products,double amount) async {
    OrderItem orderItem = OrderItem(amount: amount, products: products);
    final newOrder = await _ordersService.addOrder(orderItem);

    if(newOrder != null){
      _orders.add(newOrder);
      notifyListeners();
    }
  }
  
 

 
}