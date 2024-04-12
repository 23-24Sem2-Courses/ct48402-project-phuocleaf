import 'package:ct484_project/ui/products/products_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import NumberFormat
import '../../models/product.dart';
import '../../ui/cart/cart_manager.dart';
import '../../ui/cart/cart_screen.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  final Product product;

  const ProductDetailScreen(this.product, {Key? key}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  late ValueNotifier<bool> isFavoriteNotifier;

  @override
  void initState() {
    super.initState();
    isFavoriteNotifier = ValueNotifier(widget.product.isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    // Format price to VND
    final priceFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final formattedPrice = priceFormat.format(widget.product.price);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home_filled),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          ShoppingCartButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Image.network(
                widget.product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            formattedPrice, // Display formatted price
                            style: TextStyle(
                              color: const Color.fromARGB(255, 40, 40, 40),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: isFavoriteNotifier,
                        builder: (context, isFavorite, _) {
                          return GestureDetector(
                            onTap: () {
                              final newFavoriteStatus = !isFavorite;
                              isFavoriteNotifier.value = newFavoriteStatus;
                              widget.product.isFavorite = newFavoriteStatus;
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isFavorite
                                    ? Colors.pink
                                    : Colors.transparent,
                              ),
                              child: Icon(
                                Icons.favorite,
                                color: isFavorite ? Colors.white : Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      widget.product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              });
                            },
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ), // Add border around container
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                '$quantity', // Display quantity
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ), // Spacing between quantity and add button
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final cart = context.read<CartManager>();
                          cart.addItem(
                            widget.product,
                            quantity,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã Thêm Vào Giỏ Hàng'),
                              duration: Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () {
                                  if (widget.product.id != null) {
                                    cart.removeItem(widget.product.id!);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 205, 80, 38),
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Thêm Vào Giỏ Hàng'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
