import 'dart:convert';
import 'dart:developer';

import '../models/auth_token.dart';
import '../models/cart_item.dart';
import '../models/order_item.dart';
import 'firebase_service.dart';

class OrdersService extends FirebaseService {
  OrdersService([AuthToken? authToken]) : super(authToken);

  Future<List<OrderItem>> fetchOrders({bool filteredByUser = false}) async {
    List<OrderItem> orders = [];
    try {
     

      final ordersMap = await httpFetch(
        '$databaseUrl/orders.json?auth=$token',
      ) as Map<String, dynamic>;

      
      ordersMap.forEach((orderId, order) {
       
        orders.add(
          OrderItem(
            id: orderId,
            amount: order['amount'],
            products: (order['products'] as List<dynamic>).map((product) {
              return CartItem.fromJson(product);
            }).toList(),
            dateTime: DateTime.now(),
          ),
        );
      });

      return orders;
    } catch (error) {
      print(error);
    
      return orders;
    }
  }

  Future<OrderItem?> addOrder(OrderItem order) async {
    try{
      final newOrder = await httpFetch(
        '$databaseUrl/orders.json?auth=$token',
        method: HttpMethod.post,
        body: jsonEncode(
          order.toJson()
          ..addAll({
            'creatorId': userId,
          }),
        ),
      ) as Map<String, dynamic>?;

      return order;
    }catch (error){
      print(error);
      return null;
    }
  }

}
