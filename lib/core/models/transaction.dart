import '../helpers/helper.dart';

class Transaction {
  final String id;
  final String cashierId;
  final int tableNumber;
  final String items;
  final int total;
  final String paymentMethod;
  final String shiftType;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.cashierId,
    required this.tableNumber,
    required this.items,
    required this.total,
    required this.paymentMethod,
    required this.shiftType,
    required this.createdAt,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) => Transaction(
        id: map['id'],
        cashierId: map['cashierId'],
        tableNumber: map['tableNumber'],
        items: map['items'],
        total: map['total'],
        paymentMethod: map['payment_method'],
        shiftType: map['shift_type'],
        createdAt: DateFormatHelper.parse(map['createdAt']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'cashierId': cashierId,
        'tableNumber': tableNumber,
        'items': items,
        'total': total,
        'payment_method': paymentMethod,
        'shift_type': shiftType,
        'createdAt': DateFormatHelper.toSql(createdAt),
      };
}
