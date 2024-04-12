import 'dart:math';

import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 15.0,
      ),
    
      child: Row(
        children: [
          // Text(
          //   'Chào mừng đến với Trà Sữa của chúng tôi',
          //   style: TextStyle(
          //     color: Theme.of(context).textTheme.titleMedium?.color,
          //     fontSize: 15,
          //     fontFamily: 'Poppins',
          //     fontWeight: FontWeight.normal,
          //   ),
          // ),
          Image.asset(
            'assets/images/banner.png', // Đường dẫn hình ảnh của bạn
            width: 380, // Đặt kích thước hình ảnh
            height: 300,
          ),
          
        ],
      ),
    );
  }
}
