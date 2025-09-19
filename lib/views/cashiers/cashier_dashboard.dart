import 'package:flutter/material.dart';
import 'transaction_page.dart';
import 'expenses_page.dart';
import '../../shared/profile_page.dart';

class CashierDashboard extends StatefulWidget {
  const CashierDashboard({super.key});

  @override
  State<CashierDashboard> createState() => _cashierDashboardState();
}

class _cashierDashboardState extends State<CashierDashboard> {
  int _idx = 0;
  final _pages = [
    TransactionPage(),
    ExpensesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.point_of_sale), label: 'Jual'),
          BottomNavigationBarItem(
              icon: Icon(Icons.money), label: 'Pengeluaran'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (i) => setState(() => _idx = i),
      ),
    );
  }
}
