import '../helpers/helper.dart';

class Product {
  final String id;
  String name;
  int price;
  String category;
  String? ingredientId;
  int qtyNeeded;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.ingredientId,
    this.qtyNeeded = 0,
  });

  factory Product.fromMap(Map<String, dynamic> map) => Product(
        id: map['id'],
        name: map['name'],
        price: map['price'],
        category: map['category'],
        ingredientId: map['ingredientId'],
        qtyNeeded: map['qtyNeeded'] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'price': price,
        'category': category,
        'ingredientId': ingredientId,
        'qtyNeeded': qtyNeeded,
      };

  String get priceLabel => CurencyHelper.format(price);
}
