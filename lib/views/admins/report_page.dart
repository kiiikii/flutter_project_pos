import 'package:flutter/material.dart';
import 'package:resto_pos/widgets/ra_app_bar.dart';
import '../../core/services/report_services.dart';
import '../../core/services/pdf_services.dart';
import '../../core/helpers/helper.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _reportPageState();
}

class _reportPageState extends State<ReportPage> {
  DateTime _from = DateTime.now().subtract(Duration(days: 7));
  DateTime _to = DateTime.now();

  void _export() async {
    final sales = await ReportServices.sales(_from, _to);
    final file = await PdfServices.generateSalesReport(
      data: sales,
      range: '${_from.day}-${_to.day} ${_from.month}/${_from.year}',
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Laporan tersimpan di ${file.path}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RAAppBar(title: 'Laporan Penjualan'),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.calendar_today),
                    label:
                        Text('Dari ${_from.day}/${_from.month}/${_from.year}'),
                    onPressed: () async {
                      final pick = await showDatePicker(
                        context: context,
                        initialDate: _from,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (pick != null) setState(() => _from = pick);
                    },
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.calendar_today),
                    label: Text('Sampai ${_to.day}/${_to.month}/${_to.year}'),
                    onPressed: () async {
                      final pick = await showDatePicker(
                        context: context,
                        initialDate: _to,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (pick != null) setState(() => _from = pick);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.picture_as_pdf),
                label: Text('Export PDF'),
                onPressed: _export,
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: ReportServices.sales(_from, _to),
                builder: (_, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final list = snap.data ?? [];
                  if (list.isEmpty) {
                    return const Center(child: Text('Tidak ada data'));
                  }
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final m = list[i];
                      return ListTile(
                        title: Text('Shift: ${m['shift_type']}'),
                        subtitle: Text(m['date']),
                        trailing: Text(
                          CurencyHelper.format(m['total'] as int),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
