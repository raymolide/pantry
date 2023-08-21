// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:pantry/presentation/add.dart';
import '../application/product_service.dart';
import '../domain/models/product.dart';

class ProductListScreen extends StatefulWidget {
  final ProductService productService;

  const ProductListScreen({
    Key? key,
    required this.productService,
  }) : super(key: key);
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _search = TextEditingController();
  bool isChecked = false;
  final ProductService _productService = ProductService();
  List<Product> products = [];
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    () async {
      await _loadProducts();
      setState(() {});
    }();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    products = await _productService.getAllProducts();
  }

  Future<List<Product>> showProducts() async {
    await _loadProducts();
    if (_search.text.isEmpty) {
      _products = products;
      return _products;
    } else {
      _products = products
          .where((element) =>
              element.name.toLowerCase().contains(_search.text.toLowerCase()))
          .toList();
      return _products;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product List')),
      backgroundColor: Colors.grey.shade100,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              showModalBottomSheet(
                  elevation: 10,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: AddProductScreen(
                          productService: widget.productService),
                    );
                  });
            });
          }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 5,
                            child: TextField(
                              onEditingComplete: () {
                                setState(() {
                                  showProducts();
                                });
                              },
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    showProducts();
                                  });
                                }
                              },
                              controller: _search,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(60)),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  hintText: "Search",
                                  fillColor: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: CircleAvatar(
                                  child: InkWell(
                                    child: const Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        showProducts();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
            FutureBuilder<List<Product>>(
                future: showProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar os dados'));
                  }
                  _products = snapshot.data!;
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _products.length * 2 - 1 >= 0
                        ? _products.length * 2 - 1
                        : 0,
                    itemBuilder: (context, initialIndex) {
                      if (initialIndex.isOdd) {
                        return Divider();
                      }
                      int index = initialIndex ~/ 2;
                      return ListTile(
                          leading: Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          title: Text(_products[index].name),
                          subtitle: Text(_products[index].description),
                          trailing: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, "/edit",
                                        arguments: _products[index]);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _products.remove(_products[index]);
                                    _productService
                                        .removeProduct(_products[index].id);

                                    showProducts();
                                  },
                                ),
                              ],
                            ),
                          ));
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
