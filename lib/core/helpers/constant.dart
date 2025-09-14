class Constant {
  Constant._();

  // ---- Database ----
  static const String dbName = 'resto.db';
  static const int dbVersion = 1;

  // ---- ROLE ----
  static const String roleAdmin = 'ADMIN';
  static const String roleCashier = 'CASHIER';

  // ---- PAYMENTS, CATEGORIES, STOCK MOVEMENTS, SHIFT
  static const List<String> payments = ['CASH', 'E-WALLET', 'BANK TRANSFER'];
  static const List<String> categories = ['FOOD', 'BEVERAGE', 'SNACK'];
  static const String stockIn = 'IN';
  static const String stockOut = 'OUT';
  static const String stockAdj = 'ADJUSTMENT';
  static const String shiftMorn = 'MORNING';
  static const String shiftNoon = 'AFTERNOON';
  static const String shiftEven = 'EVENING';

  // ---- PDF ----
  static const String pdfDir = '/storage/emulated/0/Documents/Resto';
}
