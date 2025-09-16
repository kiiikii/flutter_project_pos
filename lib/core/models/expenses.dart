import '../helpers/helper.dart';

class Expenses {
  final String id;
  final String cashierId;
  final int amount;
  final String note;
  final String shiftType;
  final DateTime createdAt;

  Expenses({
    required this.id,
    required this.cashierId,
    required this.amount,
    required this.note,
    required this.shiftType,
    required this.createdAt,
  });

  factory Expenses.fromMap(Map<String, dynamic> map) => Expenses(
        id: map['id'],
        cashierId: map['cashierId'],
        amount: map['amount'],
        note: map['note'],
        shiftType: map['shiftType'],
        createdAt: DateFormatHelper.parse(map['createdAt']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'cashierId': cashierId,
        'amount': amount,
        'note': note,
        'shiftType': shiftType,
        'createdAt': DateFormatHelper.toSql(createdAt),
      };

  String get amountLabel => CurencyHelper.format(amount);
}
