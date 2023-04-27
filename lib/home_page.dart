import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_de_compras/add_product_dialog.dart';
import 'package:lista_de_compras/search_product_dialog.dart';

import 'controller.dart';

class HomePage extends GetView<Controller> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Controller());

    return Scaffold(
      drawer: const NavigationDrawer(
        children: [
          NavigationDrawerDestination(
            icon: Icon(Icons.logout),
            label: Text('Deslogar'),
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text('Lista de Compras'),
        actions: [
          IconButton(
            onPressed: () => searchProductDialog(context),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Adicionar Produto'),
        icon: const Icon(Icons.add_shopping_cart),
        onPressed: () => showAddProductDialog(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.products.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(controller.products[index].name),
                    subtitle: Text(
                        'R\$${controller.products[index].value.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        controller.removeProductFromList(index);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 150,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Text(
                    'Valor Total R\$${controller.getListTotalPrice}',
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
