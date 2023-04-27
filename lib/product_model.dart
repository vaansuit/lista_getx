class ProductModel {
  String id;
  String name;
  double value;

  ProductModel({
    required this.id,
    required this.name,
    required this.value,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'value': value,
      };
}
