import 'package:sqflite/sqflite.dart';

import '../../domain/models/product.dart';
import 'database_provider.dart';

class ProductDAO {
  Future<void> insertProduct(Product product) async {
    final db = await DatabaseProvider.instance.database;
    await db.insert('products', product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Product>> getAllProducts() async {
    final db = await DatabaseProvider.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<void> updateProduct(Product product) async {
    final db = await DatabaseProvider.instance.database;
    await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> deleteProduct(int productId) async {
    final db = await DatabaseProvider.instance.database;
    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  Future<Product> getProduct(int productId) async {
    final db = await DatabaseProvider.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
    );

    return Product.fromMap(maps.first);
  }
}
