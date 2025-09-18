import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:resto_pos/core/helpers/helper.dart';
import '../helpers/constant.dart';

class PdfServices {
  static Future<File> generateSalesReport(
      {required List<Map<String, dynamic>> data, required String range}) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Resto - Laporan Penjualan',
                style: pw.TextStyle(fontSize: 24)),
            pw.Text('Periode: $range'),
            pw.SizedBox(height: 20),
            // ignore: deprecated_member_use
            pw.Table.fromTextArray(
              headers: ['Tanggal', 'Shift', 'Total'],
              data: data
                  .map((e) => [
                        e['date'],
                        e['shift'],
                        CurencyHelper.format(e['total']),
                      ])
                  .toList(),
            ),
          ],
        ),
      ),
    );

    final dir = Directory(Constant.pdfDir);
    if (!await dir.exists()) await dir.create(recursive: true);
    final file = File('${dir.path}/sales_$range.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
