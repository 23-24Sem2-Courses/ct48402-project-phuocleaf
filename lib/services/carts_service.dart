import 'dart:convert';

import '../models/auth_token.dart';
import '../models/cart_item.dart';
import 'firebase_service.dart';

class CartsService extends FirebaseService {
  CartsService([AuthToken? authToken]) : super(authToken);

  Future<Map<String, CartItem>> fetchCarts({bool filteredByUser = false}) async {
    final Map<String, CartItem> cart = {};

    try {
      final filters =
          filteredByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

      final cartsMap = await httpFetch(
        '$databaseUrl/carts.json?auth=$token&$filters',
      ) as Map<String, dynamic>;


      cartsMap.forEach((cartId, cartitem) {
          cart[cartId] = CartItem.fromJson({
            ...cartitem});
       
      });
      return cart;
    } catch (error) {
      print(error);
      return cart;
    }
  }

  Future<Map<String, dynamic>?> addCart(CartItem newItem) async {
    
    try{
     
      final newCart = await httpFetch(
        '$databaseUrl/carts.json?auth=$token',
        method: HttpMethod.post,
        body: jsonEncode({
          'id': newItem.id,
          ...newItem.toJson(),        
        }),
      ) as Map<String, dynamic>? ;
      
      return newCart;
    }catch(error){
      print(error);
      return null;
    }
  }

  Future<bool> updateCart(CartItem cartItem) async {
    try{
      await httpFetch(
        '$databaseUrl/carts/${cartItem.id}.json?auth=$token',
        method: HttpMethod.patch,
        body: jsonEncode(
          cartItem.toJson()
        ),
      );
      return true;
    }catch (error){
      print(error);
      return false;
    }
  }
  Future<bool> deleteCart(String id) async {
    try{
      await httpFetch(
        '$databaseUrl/carts/$id.json?auth=$token',
        method: HttpMethod.delete,
      );
      return true;
    }catch (error){
      print(error);
      return false;
    }
  }

  
}