import 'package:pantry/domain/models/product.dart';

abstract class IProductRepository {
  Future<List<Product>> getAll();
  Future<Product> get(int id);
  Future<void> insert(Product product);
  Future<void> update(Product product);
  Future<void> remove(int id);
}
