import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'product_model.dart';

class Controller extends GetxController {
  //Começar criando uma lista de produtos vazia
  final products = <ProductModel>[].obs;

  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  double get getListTotalPrice =>
      products.fold(0.0, (sum, product) => sum + product.value);

  void addProductToList() {
    final name = productNameController.text.trim();
    final value = double.tryParse(productPriceController.text.trim());

    if (name.isNotEmpty && value != null) {
      products.add(ProductModel(name: name, value: value));
      productNameController.clear();
      productPriceController.clear();
      products.sort((a, b) => b.value.compareTo(a.value));
      update();
    }
  }

  void removeProductFromList(int index) {
    products.removeAt(index);
  }

  void searchProduct(String query) {
    if (query.isEmpty) {
      return;
    }

    final results = products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      Get.snackbar('Nenhum item encontrado', 'Tente outra busca',
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.grey[800],
          colorText: Colors.white);
    } else {
      Get.defaultDialog(
        title: 'Resultados da busca',
        content: Container(
          height: 200,
          width: 200,
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: results.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = results[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('R\$${product.value.toStringAsFixed(2)}'),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    productNameController.dispose();
    productPriceController.dispose();
    super.dispose();
  }
}
