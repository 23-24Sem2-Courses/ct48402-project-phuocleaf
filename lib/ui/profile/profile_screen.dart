import 'package:flutter/material.dart';
import '../../ui/cart/cart_manager.dart';
import '../../ui/orders/order_manager.dart';
import '../../ui/products/products_manager.dart';
import 'package:provider/provider.dart';

import '../auth/auth_manager.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authToken = context.read<AuthManager>().authToken;
    final products = context.read<ProductsManager>().items;
    final carts = context.read<CartManager>().products;
    final orders = context.read<OrdersManager>().orders;
    final email = authToken!.email;
    return Scaffold(
      appBar: AppBar(
        title: Text('Xin chào ${email.split('@')[0].toUpperCase()}!'),
      ),
      body: ListView(
        children: <Widget>[
          const Divider(),
          buildInformationField(
            icon: const Icon(Icons.email),
            content: email,
          ),
          const Divider(),
          buildInformationField(
            icon: const Icon(Icons.bar_chart_outlined),
            content: '${products.length} Sản phẩm',
          ),
          const Divider(),
          buildInformationField(
            icon: const Icon(Icons.shopping_cart),
            content: '${carts.length} Sản phẩm trong giỏ hàng',
          ),
          const Divider(),
          buildInformationField(
            icon: const Icon(Icons.shopping_bag),
            content: '${orders.length} Hóa đơn',
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.only(left: 20),
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Xác nhận'),
                      content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Đăng xuất khi người dùng chọn "Đồng ý"
                            context.read<AuthManager>().logout();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Đồng ý'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.teal,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Đăng xuất')
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildInformationField({
    required Icon icon,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 30),
      child: Column(
        children: [
          Row(
            children: [
              icon,
              const SizedBox(
                width: 10,
              ),
              Text(content),
            ],
          ),
        ],
      ),
    );
  }
}
