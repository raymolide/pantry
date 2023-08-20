import 'package:flutter/material.dart';
import 'package:pantry/presentation/add.dart';
import 'package:pantry/presentation/edit.dart';
import 'package:pantry/presentation/list.dart';

import 'application/product_service.dart';
import 'data/database/database_provider.dart';
import 'domain/models/product.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseProvider.instance.database;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    ProductService productService = ProductService();
    return MaterialApp(
      title: 'Pantry',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      routes: {
        '/list': (context) => ProductListScreen(productService: productService),
        '/add': (context) => AddProductScreen(productService: productService),
        '/edit': (context) {
          final product = ModalRoute.of(context)?.settings.arguments as Product;
          return EditProductScreen(product);
        },
      },
      home: ProductListScreen(
        productService: productService,
      ),
    );
  }
}
