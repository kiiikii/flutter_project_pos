import 'package:intl/intl.dart';
import 'constant.dart';

/// Convert INT (stored in db) to DOUBLE for UI (2 decimals).
/// Save back INT (multiply by 100) to keep precision.
class CurencyHelper {
  static double toDouble(int amount) => amount / 100;
  static int toInt(double amount) => (amount * 100).round();
  static String format(int amount) =>
      'Rp ${toDouble(amount).toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          )}';
}

/// DateFormat helper
class DateFormatHelper {
  static final DateFormat _sql = DateFormat('dd/MM/yyyy HH:mm:ss');
  static final DateFormat _human = DateFormat('dd/MM/yyyy HH:mm');

  static DateTime parse(String sql) => DateTime.parse(sql);
  static String toSql(DateTime dt) => _sql.format(dt.toUtc());
  static String toHuman(DateTime dt) => _human.format(dt);
}

/// Shifting helper
class ShiftHelper {
  static String current() {
    final h = DateTime.now().hour;
    if (h < 12) return Constant.shiftMorn;
    if (h < 18) return Constant.shiftNoon;
    return Constant.shiftEven;
  }
}
