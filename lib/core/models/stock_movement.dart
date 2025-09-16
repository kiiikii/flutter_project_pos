import '../helpers/helper.dart';

class StockMovement {
  final String id;
  final String ingredientId;
  final String type;
  final int qty;
  final String? note;
  final DateTime createdAt;

  StockMovement({
    required this.id,
    required this.ingredientId,
    required this.type,
    required this.qty,
    this.note,
    required this.createdAt,
  });

  factory StockMovement.fromMap(Map<String, dynamic> map) => StockMovement(
        id: map['id'],
        ingredientId: map['ingredientId'],
        type: map['type'],
        qty: map['qty'],
        note: map['note'],
        createdAt: DateFormatHelper.parse(map['CreatedAt']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'ingredientId': ingredientId,
        'type': type,
        'qty': qty,
        'note': note,
        'createdAt': DateFormatHelper.toSql(createdAt),
      };
}
