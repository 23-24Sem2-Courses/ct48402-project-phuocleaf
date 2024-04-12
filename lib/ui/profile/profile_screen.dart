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
          buildInformationField(
            icon: const Icon(Icons.email),
            content: email,
          ),
          const SizedBox(height: 10),
          buildInformationField(
            icon: const Icon(Icons.shopping_bag),
            content: '${carts.length} Sản phẩm trong giỏ hàng',
          ),
          const SizedBox(height: 10),
          buildInformationField(
            icon: const Icon(Icons.library_books),
            content: '${orders.length} Hóa đơn',
          ),
          const SizedBox(height: 10),
          // Nút "Đăng xuất" cũng được đặt trong một Container có bo góc
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.exit_to_app),
                  const SizedBox(width: 10),
                  const Text(
                    'Đăng xuất',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildInformationField({
    required Icon icon,
    required String content,
  }) {
    return Container(
      
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color.fromARGB(64, 206, 206, 206), 
        borderRadius: BorderRadius.circular(10), 
        
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
