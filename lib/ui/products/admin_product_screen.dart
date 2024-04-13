import 'package:flutter/material.dart';
import 'package:ct484_project/ui/screen.dart';
import 'package:provider/provider.dart';

import 'admin_product_list_tile.dart';

import '../shared/app_drawer.dart';

import 'products_manager.dart';

class AdminProductsScreen extends StatelessWidget {

  static const routeName = '/user-products';

  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Sản Phẩm'),
        actions: <Widget>[
          AddAdminProductButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
              );
              print('Go to edit product screen');
            },
          ),
        ],
      ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future: context.read<ProductsManager>().fetchUsersProducts(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<ProductsManager>().fetchUsersProducts(),
              child: const AdminProductList(),
            );
          },
        ),
    );
  }
}

class AdminProductList extends StatelessWidget {
  const AdminProductList({super.key});

  @override
  Widget build(BuildContext context) {
    final productsManager = ProductsManager();
  
    return Consumer<ProductsManager>(
      builder: (ctx, productsManager, child) {
      return ListView.builder(
        itemCount: productsManager.itemCount,
        itemBuilder: (ctx, i) => Column(
          children: [
            AdminProductListTile(
              productsManager.items[i],
            ),
            const Divider(),
          ],
        ),
      );
    },
  );
  }
}

class AddAdminProductButton extends StatelessWidget {
  const AddAdminProductButton({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: onPressed,
    );
  }
}
