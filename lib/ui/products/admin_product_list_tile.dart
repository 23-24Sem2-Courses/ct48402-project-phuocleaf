import 'package:flutter/material.dart';
import 'package:ct484_project/ui/products/products_manager.dart';
import 'package:ct484_project/ui/screen.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';

class AdminProductListTile extends StatelessWidget {
  final Product product;

  const AdminProductListTile(
    this.product, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            EditAdminProductButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: product.id,
                );
                print('Go to edit product screen');
              },
            ),
            DeleteAdminProductButton(
              onPressed: () {
                context.read<ProductsManager>().deleteProduct(product.id!);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                    content: Text(
                      'Đã Xóa Sản Phẩm',
                      textAlign: TextAlign.center,
                    ),
                  ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteAdminProductButton extends StatelessWidget {
  const DeleteAdminProductButton({
    super.key,
    this.onPressed,
  });

  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete_rounded),
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.error,
    );
  }
}

class EditAdminProductButton extends StatelessWidget {
  const EditAdminProductButton({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.note_alt_rounded),
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
