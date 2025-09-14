import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import '../helpers/constant.dart';

class DbService {
  DbService._();
  static final DbService instance = DbService._();
  static Database? _db;

  Future<Database> get db async => _db ??= await _init();

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), Constant.dbName);
    return openDatabase(path, version: Constant.dbVersion, onCreate: _create);
  }

  Future _create(Database db, int version) async {
    // ---- USERS ----
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL CHECK(role IN ('admin','cashier'))
      )
    ''');
    // ---- INGREDIENTS ----
    await db.execute('''
      CREATE TABLE ingredients(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        stock INTEGER NOT NULL DEFAULT 0,
        unit TEXT NOT NULL
      )
    ''');
    // ---- PRODUCTS ----
    await db.execute('''
      CREATE TABLE products(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        price INTEGER NOT NULL,
        category TEXT NOT NULL CHECK(category IN ('food','beverage','snack')) DEFAULT 'food',
        ingredientId TEXT REFERENCES ingredients(id) ON DELETE SET NULL,
        qtyNeeded INTEGER NOT NULL DEFAULT 0
      )
    ''');
    // ---- TRANSACTIONS ----
    await db.execute('''
      CREATE TABLE transactions(
        id TEXT PRIMARY KEY,
        cashierId TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        tableNumber INTEGER NOT NULL,
        items TEXT NOT NULL,
        total INTEGER NOT NULL,
        payment_method TEXT NOT NULL CHECK(payment_method IN ('cash','e-wallet','bank transfer')),
        shift_type TEXT NOT NULL CHECK(shift_type IN ('morning','afternoon','evening','daily')),
        createdAt TEXT NOT NULL
      )
    ''');
    // ---- EXPENSES ----
    await db.execute('''
      CREATE TABLE expenses(
        id TEXT PRIMARY KEY,
        cashierId TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        amount INTEGER NOT NULL,
        note TEXT NOT NULL,
        shift_type TEXT NOT NULL CHECK(shift_type IN ('morning','afternoon','evening','daily')),
        createdAt TEXT NOT NULL
      )
    ''');
    // ---- STOCK MOVEMENTS ----
    await db.execute('''
      CREATE TABLE stock_movements(
        id TEXT PRIMARY KEY,
        ingredientId TEXT NOT NULL REFERENCES ingredients(id) ON DELETE CASCADE,
        type TEXT NOT NULL CHECK(type IN ('IN','OUT','ADJUSTMENT')),
        qty INTEGER NOT NULL,
        note TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // ---- SEED DEFAULT ADMINS ----
    const admin = User(
      id: 'admin-001',
      name: 'Owner',
      email: 'admin@resto.com',
      password: '123456', // hash me later
      role: Constant.roleAdmin, // ← lower-case constant
    );
    await db.insert('users', admin.toMap());
  }
}
