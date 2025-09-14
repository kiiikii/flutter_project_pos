import 'package:intl/intl.dart';

class CurencyHelper {
  static double toDouble(int amount) => amount / 100;
  static int toInt(double amount) => (amount * 100).round();
  static String format(int amount) =>
      'Rp ${toDouble(amount).toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          )}';
}

class DateFormatHelper {
  static final DateFormat _sql = DateFormat('dd/MM/yyyy HH:mm:ss');
  static final DateFormat _human = DateFormat('dd/MM/yyyy HH:mm');

  static DateTime parse(String sql) => DateTime.parse(sql);
  static String toSql(DateTime dt) => _sql.format(dt.toUtc());
  static String toHuman(DateTime dt) => _human.format(dt);
}
