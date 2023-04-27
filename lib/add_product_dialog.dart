import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

Future<void> showAddProductDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        final controller = Get.put(Controller());

        return AlertDialog(
          title: const Text('Adicione um produto!'),
          content: SizedBox(
            width: 500,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextField(
                  controller: controller.productNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Produto',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: controller.productPriceController,
                  decoration: const InputDecoration(
                    labelText: 'Preço do Produto',
                    border: OutlineInputBorder(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.addProductToList();
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            ),
          ),
        );
      });
}
