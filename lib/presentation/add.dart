// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:pantry/domain/models/product.dart';

import '../application/product_service.dart';

class AddProductScreen extends StatefulWidget {
  final ProductService productService;
  const AddProductScreen({
    Key? key,
    required this.productService,
  }) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ProductService _productService = ProductService();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late TextEditingController _unitController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: '');
    _priceController = TextEditingController(text: '');
    _quantityController = TextEditingController(text: '');
    _unitController = TextEditingController(text: '');
    _descriptionController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    var products = await _productService.getAllProducts();
    int id = products.isNotEmpty ? products.last.id + 1 : 1;
    Product product = Product(
        id: id,
        name: _nameController.text,
        price: double.parse(_priceController.text),
        quantity: double.parse(_quantityController.text),
        unit: _unitController.text,
        description: _descriptionController.text);

    _productService.insertProduct(product);
    _productService.getAllProducts();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _unitController,
              decoration: InputDecoration(labelText: 'Unit'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _saveChanges();
                });
              },
              child: Text('Save Product'),
            ),
          ],
        ),
      ),
    );
  }
}
