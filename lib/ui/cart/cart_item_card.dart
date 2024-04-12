import 'package:flutter/material.dart';
import 'package:ct484_project/ui/cart/cart_manager.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/cart_item.dart';
import '../shared/dialog_utils.dart';

class CartItemCard extends StatelessWidget {
  final String productId;
  final CartItem cartItem;

  const CartItemCard({
    required this.productId,
    required this.cartItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showConfirmDialog(
          context,
          'Bạn Muốn Xóa Sản Phẩm Khỏi Giỏ Hàng?',
        );
      },
      onDismissed: (direction) {
        print('Cart item dismissed');
        context.read<CartManager>().removeItem(productId);
      },
      child: ItemInfoCard(cartItem),
    );
  }
}

class ItemInfoCard extends StatelessWidget {
  const ItemInfoCard(
    this.cartItem, {
    super.key,
  });

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final totalAmount = cartItem.price * cartItem.quantity;
    final formattedTotalAmount = currencyFormat.format(totalAmount);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              cartItem.imageUrl,
              fit: BoxFit.cover,
              width: 60,
              height: 60,
            ),
          ),
          title: Text(cartItem.title),
          subtitle: Text('Tổng: $formattedTotalAmount'),
          trailing: Text(
            '${cartItem.quantity} x $formattedTotalAmount',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
