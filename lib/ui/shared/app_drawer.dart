import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_manager.dart';
import '../orders/orders_screen.dart';
import '../products/admin_product_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer ({super.key});

  @override
  Widget build(BuildContext context) {
    final authToken = context.read<AuthManager>().authToken;
    final email = authToken!.email;
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Xin chào Admin!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
        
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Đăng xuất'),
            onTap: () {
              Navigator.of(context)
                ..pop()
                ..pushReplacementNamed('/');
              context.read<AuthManager>().logout();
            },
          ),
        ],
      ),
    );
  }
}