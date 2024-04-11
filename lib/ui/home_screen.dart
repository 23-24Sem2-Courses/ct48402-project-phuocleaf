import 'package:flutter/material.dart';
import 'package:ct484_project/ui/profile/profile_screen.dart';
import 'package:ct484_project/ui/screen.dart';
import 'package:flutter/widgets.dart';

import '../ui/products/products_overview_screen.dart';
import '../ui/products/products_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
    { super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  
  final List<Widget> _widgetOptions = [
    const ProductsOverviewScreen(),
    const OrderScreen(),
    const ProfileScreen(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.space_dashboard_sharp),
            label: 'Đơn hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_sharp),
            label: 'Cá nhân'
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary, // Sử dụng màu chính của ứng dụng
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
