import 'package:ct484_project/ui/products/products_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ct484_project/models/product.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import 'ui/screen.dart';
import 'ui/home_screen.dart';


Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Color.fromARGB(205, 16, 129, 164),
      secondary: Colors.deepOrange,
      background: Colors.white,
      surfaceTint: Colors.grey[200],
    );

    final themeData = ThemeData(
      fontFamily: 'Poppins',
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        //shadowColor: colorScheme.shadow,
      ),
    );

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: themeData.appBarTheme.backgroundColor, // Color của AppBar
      //statusBarBrightness: Brightness.light, // Độ sáng của StatusBar
      statusBarIconBrightness: Brightness.light,
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthManager(),
        ),
        ChangeNotifierProxyProvider<AuthManager, ProductsManager>(
          create: (ctx) => ProductsManager(),
          update: (ctx, authManager, productsManager) {
            productsManager!.authToken = authManager.authToken;
            return productsManager;
          },
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartManager(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrdersManager(),
        ),
      ],
      child: Consumer<AuthManager>(
        builder: (ctx, authManager, child) {
          // Widget homeScreen;

          // if (authManager.isAuth) {
          //   if (authManager.userRole == UserRole.admin) {
          //     homeScreen = AdminHomeScreen(); 
          //   } else {
          //     homeScreen = HomeScreen();
          //   }
          // } else {
          //   homeScreen = FutureBuilder(
          //     future: authManager.tryAutoLogin(),
          //     builder: (ctx, snapshot) {
          //       return snapshot.connectionState == ConnectionState.waiting
          //           ? const SplashScreen()
          //           : const AuthScreen();
          //     },
          //   );
          // }
          return MaterialApp(
            title: 'Shop',
            debugShowCheckedModeBanner: false,
            theme: themeData,
            home: 
            //SafeArea(child: homeScreen),
            authManager.isAuth
                ? (authManager.isAdmin!) ? const AdminProductsScreen() :const SafeArea(child: HomeScreen())
                : FutureBuilder(
                    future: authManager.tryAutoLogin(),
                    builder: (ctx, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const SafeArea(child: SplashScreen())
                          : const SafeArea(child: AuthScreen());
                    },
                  ),
            routes: {
              CartScreen.routeName: (ctx) => const SafeArea(
                    child: CartScreen(),
                  ),
              OrderScreen.routeName: (ctx) => const SafeArea(
                    child: OrderScreen(),
                  ),
              AdminProductsScreen.routeName: (ctx) => const SafeArea(
                    child: AdminProductsScreen(),
                  ),
              ProductsOverviewScreen.routeName: (ctx) => const SafeArea(
                    child: ProductsOverviewScreen(),
                  ),
            },
            onGenerateRoute: (settings) {
              if (settings.name == ProductDetailScreen.routeName) {
                final productId = settings.arguments as String;
                return MaterialPageRoute(
                  builder: (ctx) {
                    return SafeArea(
                      child: ProductDetailScreen(
                          ctx.read<ProductsManager>().findById(productId)!),
                    );
                  },
                );
              }

              if (settings.name == EditProductScreen.routeName) {
                final productId = settings.arguments as String?;
                return MaterialPageRoute(
                  builder: (ctx) {
                    return SafeArea(
                      child: EditProductScreen(
                        productId != null
                            ? ctx.read<ProductsManager>().findById(productId)
                            : null,
                      ),
                    );
                  },
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
