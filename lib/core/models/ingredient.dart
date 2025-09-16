class Ingredient {
  final String id;
  String name;
  int stock;
  String unit;

  Ingredient({
    required this.id,
    required this.name,
    required this.stock,
    required this.unit,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) => Ingredient(
        id: map['id'],
        name: map['name'],
        stock: map['stock'],
        unit: map['unit'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'stock': stock,
        'unit': unit,
      };
}
