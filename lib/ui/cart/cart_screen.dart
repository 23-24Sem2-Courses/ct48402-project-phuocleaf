import 'package:flutter/material.dart';
import 'package:ct484_project/models/cart_item.dart';
import 'package:ct484_project/models/product.dart';
import 'package:ct484_project/ui/orders/order_manager.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'cart_manager.dart';

import 'cart_item_card.dart';

import 'cart_screen.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<void> _fetchCartItems;

  @override
  void initState() {
    super.initState();
    _fetchCartItems = context.read<CartManager>().fetchCarts();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartManager>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ Hàng Của Bạn'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: CartItemList(cart),
          ),
          CartSummary(
            cart: cart,
            onOrderNowPressed: cart.totalAmount <= 0
                ? null
                : () {
                    context.read<OrdersManager>().addOrder(
                          cart.products,
                          cart.totalAmount,
                        );
                    cart.clearAllItem();
                  },
          ),
        ],
      ),
    );
  }
}

class CartItemList extends StatelessWidget {
  final CartManager cart;

  const CartItemList(this.cart, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: cart.productEntries
          .map(
            (entry) => Column(
              children: [
                CartItemCard(
                  productId: entry.key,
                  cartItem: entry.value,
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}

class CartSummary extends StatelessWidget {
  final CartManager cart;
  final void Function()? onOrderNowPressed;

  const CartSummary({
    required this.cart,
    this.onOrderNowPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final formattedAmount = currencyFormat.format(cart.totalAmount);

    return Container(
      
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
             
            const Text(
              'Tổng cộng',
              style: TextStyle(fontSize: 18),
            ),
            const Spacer(), 
            Chip(
              label: Text(
                formattedAmount,
                style: Theme.of(context).primaryTextTheme.titleLarge,
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            const Spacer(),
            TextButton(
              onPressed: onOrderNowPressed,
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: const Text('Đặt Ngay'),
            )
          ],
        ),
      ),
    );
  }
}
