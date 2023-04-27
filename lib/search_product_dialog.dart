import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

Future<void> searchProductDialog(BuildContext context) {
  final controller = Get.find<Controller>();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search products'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Product name',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (query) {
              controller.searchProduct(query);
            },
          ),
        );
      });
}
