import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'product_model.dart';

class Controller extends GetxController {
  final products = <ProductModel>[].obs;

  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  double get getListTotalPrice =>
      products.fold(0.0, (sum, product) => sum + product.value);

  // void addProductToList() {
  //   final name = productNameController.text.trim();
  //   final value = double.tryParse(productPriceController.text.trim());

  //   if (name.isNotEmpty && value != null) {
  //     products.add(ProductModel(name: name, value: value, id: ''));

  //     products.sort((a, b) => b.value.compareTo(a.value));
  //     update();
  //   }
  // }

  // void removeProductFromList(int index) {
  //   products.removeAt(index);
  // }

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

  Future addProductToFirestore() async {
    final name = productNameController.text.trim();
    final value = double.tryParse(productPriceController.text.trim());

    if (name.isNotEmpty && value != null) {
      final product = {'name': name, 'value': value};
      final docRef =
          await FirebaseFirestore.instance.collection('product').add(product);
      final id = docRef.id;
      final newProduct = ProductModel(id: id, name: name, value: value);
      products.add(newProduct);
      productNameController.clear();
      productPriceController.clear();
      products.sort((a, b) => b.value.compareTo(a.value));
      update();
    }
  }

  Future<void> deleteProductFromFirestore(String id) async {
    try {
      final index = products.indexWhere((product) => product.id == id);

      if (index == -1) {
        throw Exception('Produto não encontrado');
      }
      await FirebaseFirestore.instance.collection('product').doc(id).delete();
      products.removeAt(index);

      update();

      Get.snackbar('Produto deletado!', 'O produto foi deletado com sucesso!',
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Erro ao deletar produto!', '$e',
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> editProductFromFirestore(String id) async {
    try {
      final index = products.indexWhere((product) => product.id == id);
      if (index == -1) {
        throw Exception('Produto não encontrado');
      }

      final currentName = products[index].name;
      final currentValue = products[index].value;

      final newNameController = TextEditingController(text: currentName);
      final newValueController = TextEditingController(text: '$currentValue');

      await showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text('Editar produto'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: newNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                  ),
                ),
                TextField(
                  controller: newValueController,
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  final newName = newNameController.text.trim();
                  final newValue =
                      double.tryParse(newValueController.text.trim());
                  if (newName.isNotEmpty && newValue != null) {
                    await FirebaseFirestore.instance
                        .collection('product')
                        .doc(id)
                        .update({'name': newName, 'value': newValue});

                    products[index] =
                        ProductModel(id: id, name: newName, value: newValue);

                    update();

                    Get.snackbar('Produto atualizado!',
                        'O produto foi atualizado com sucesso!',
                        duration: const Duration(seconds: 3),
                        backgroundColor: Colors.green,
                        colorText: Colors.white);

                    Get.back();
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      Get.snackbar('Erro ao editar produto!', '$e',
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  void dispose() {
    productNameController.dispose();
    productPriceController.dispose();
    super.dispose();
  }
}
