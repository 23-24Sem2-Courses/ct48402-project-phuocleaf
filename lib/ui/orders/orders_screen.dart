import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_manager.dart';

import '../shared/app_drawer.dart';

import 'order_item_card.dart';

class OrderScreen extends StatefulWidget {

  static const routeName = '/orders';

  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future<void> _fetchOrderItems;

  @override
  void initState(){
    super.initState();
    _fetchOrderItems = context.read<OrdersManager>().fetchOrders();
  }
  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: Consumer<OrdersManager>(
        builder: (ctx, ordersManager, child) {
          return ListView.builder(
            itemCount: ordersManager.orderCount,
            itemBuilder: (ctx, i) =>
              OrderItemCard(ordersManager.orders[i]),
          );
        },
      ),
    );
  }
}