import 'package:flutter/material.dart';
import 'package:ct484_project/ui/cart/cart_manager.dart';
import 'package:ct484_project/ui/products/product_detail_screen.dart';
import 'package:ct484_project/ui/products/products_manager.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';

class ProductGridTile extends StatelessWidget {
  const ProductGridTile(
    this.product, {
    super.key,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: 
        ProductGridFooter(
          product: product,
          onFavoritePressed: () {
            context.read<ProductsManager>().toggleFavoriteStatus(product);
          },
          onAddToCartPressed: () {
            print('Add item to cart');
            final cart = context.read<CartManager>();
            cart.addItem(product, 1);

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: const Text(
                    'Đã Thêm Vào Giỏ Hàng',
                  ),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeItem(product.id!);
                    },
                  ),
                ),
              );
          },
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class ProductGridFooter extends StatelessWidget {
  const ProductGridFooter({
    super.key,
    required this.product,
    this.onFavoritePressed,
    this.onAddToCartPressed,
  });
  final Product product;
  final void Function()? onFavoritePressed;
  final void Function()? onAddToCartPressed;
  @override
  Widget build(BuildContext context) {
    return GridTileBar(
      backgroundColor: Color.fromARGB(144, 204, 201, 201),
      title: Row(
        children: [
          Expanded(
            child: Text(
              product.title,
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color.fromARGB(242, 38, 38, 38), 
                fontSize: 15, 
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins', 
              ),
            ),
          ),
        ],
      ),

      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: product.isFavoriteListenable,
            builder: (ctx, isFavorite, child) {
              return GestureDetector(
                onTap: onFavoritePressed,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFavorite ? Colors.pink : Colors.grey,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              );
            },
          ),

          IconButton(
            icon: Icon(
              Icons.add_circle,
              size: 30,
            ),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: onAddToCartPressed,
          ),
        ],
      ),
      
    );
  }
}
