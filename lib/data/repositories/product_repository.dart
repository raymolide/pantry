import 'package:pantry/data/database/product_dao.dart';
import 'package:pantry/domain/models/product.dart';
import 'package:pantry/domain/repositories/IProductRepository.dart';

class ProductRepository implements IProductRepository {
  final ProductDAO _db = ProductDAO();

  @override
  Future<List<Product>> getAll() async {
    return _db.getAllProducts();
  }

  @override
  Future<Product> get(int id) async {
    return _db.getProduct(id);
  }

  @override
  Future<void> insert(Product product) async {
    _db.insertProduct(product);
  }

  @override
  Future<void> remove(int id) async {
    _db.deleteProduct(id);
  }

  @override
  Future<void> update(Product product) async {
    _db.updateProduct(product);
  }
}
