// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pantry/data/repositories/product_repository.dart';

import '../domain/models/product.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();

  factory ProductService() {
    return _instance;
  }

  ProductService._internal();

  ProductRepository _productRepository = ProductRepository();

  Future<List<Product>> getAllProducts() async {
    return _productRepository.getAll();
  }

  Future<Product> getProduct(int id) async {
    return _productRepository.get(id);
  }

  Future<void> insertProduct(Product product) async {
    _productRepository.insert(product);
  }

  Future<void> updateProduct(Product product) async {
    _productRepository.update(product);
  }

  Future<void> removeProduct(int id) async {
    _productRepository.remove(id);
  }
}
