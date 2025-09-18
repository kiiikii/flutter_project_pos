import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:resto_pos/widgets/ra_app_bar.dart';
import '../../core/services/report_services.dart';
import '../../core/services/chart_services.dart';
import '../../widgets/ra_drawer.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late Future<List<Map<String, dynamic>>> _salesRaw;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final weekAgo = today.subtract(const Duration(days: 7));
    _salesRaw = ReportServices.sales(weekAgo, today);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RAAppBar(title: 'Admin Dashboard'),
      drawer: const RADrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard('Penjualan 7 hari', _salesChart()),
            const SizedBox(height: 16),
            _buildCard('Pengeluaran 7 hari', _expenseChart()),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, Widget chart) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(height: 200, child: chart),
          ],
        ),
      ),
    );
  }

  Widget _salesChart() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _salesRaw,
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return LineChart(ChartServices.salesLine(snap.data!));
      },
    );
  }

  Widget _expenseChart() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ReportServices.expenses(
        DateTime.now().subtract(const Duration(days: 7)),
        DateTime.now(),
      ),
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return BarChart(ChartServices.expensesBar(snap.data!));
      },
    );
  }
}
