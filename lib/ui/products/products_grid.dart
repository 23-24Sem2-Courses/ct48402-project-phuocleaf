import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_grid_tile.dart';
import 'products_manager.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../models/product.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;

  const ProductsGrid(this.showFavorites, {super.key});

  @override
  Widget build(BuildContext context) {
    final products = context.select<ProductsManager, List<Product>>(
        (productsManager) => showFavorites
            ? productsManager.favoriteItems
            : productsManager.items);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
          items: [
            Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjg7Znku79ueYHcateuYNvwr7N2xGmQKEmtOiuKV4GpQ&s',
              fit: BoxFit.cover, 
            ),
            Image.network(
              'https://feelingteaonline.com/wp-content/uploads/2020/07/menu1.jpg',
              fit: BoxFit.cover,
            ),
            Image.network(
              'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSxiBSELbXcTZCIjIn-ZmQ74FYwK8hXFIKeGkrKjozRM61TckL_',
              fit: BoxFit.cover,
            ),
             Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIz-BWREoB29m0flsr-YKwnIn2uP3yuKNh2AogkrEQSJuBntWQWTSTTkbrrdI_uzkhNzg&usqp=CAU',
              fit: BoxFit.cover,
            ),
            
          ],
          options: CarouselOptions(
            height: 175, // Độ cao của slider
            aspectRatio: 16 / 9,
            viewportFraction: 1, // Tỷ lệ ảnh hiển thị trong viewport
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Sản Phẩm',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(242, 38, 38, 38),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: products.length,
            itemBuilder: (ctx, i) => ProductGridTile(products[i]),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4 / 5,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
          ),
        ),
      ],
    );
  }
}
