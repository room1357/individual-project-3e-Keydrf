import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';
import '../utils/save_utils.dart';

class ExportScreen extends StatelessWidget {
  final List<Expense> expenses;

  const ExportScreen({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Export Data Pengeluaran',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.indigo.withOpacity(0.05),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Format Export:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 30),

            // Tombol Export CSV
            ElevatedButton.icon(
              icon: const Icon(Icons.table_chart, color: Colors.white),
              label: const Text(
                'Export ke CSV',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
              onPressed: () async {
                await _exportToCSV(context);
              },
            ),
            const SizedBox(height: 20),

            // Tombol Export PDF
            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
              label: const Text(
                'Export ke PDF',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
              onPressed: () async {
                await _exportToPDF(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ===================== EXPORT KE CSV ======================
  Future<void> _exportToCSV(BuildContext context) async {
    try {
      final List<List<dynamic>> rows = [
        ['Judul', 'Kategori', 'Tanggal', 'Jumlah (Rp)'],
        ...expenses.map((e) => [
              e.title,
              e.category,
              DateFormat('dd-MM-yyyy').format(e.date),
              e.amount,
            ])
      ];

      String csvData = const ListToCsvConverter().convert(rows);

      await saveCSV(csvData, 'pengeluaran.csv');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            kIsWeb
                ? 'CSV berhasil di-download di Web'
                : 'CSV berhasil disimpan',
          ),
          backgroundColor: Colors.indigo,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal export CSV: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// ===================== EXPORT KE PDF ======================
  Future<void> _exportToPDF(BuildContext context) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Laporan Pengeluaran',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: ['Judul', 'Kategori', 'Tanggal', 'Jumlah (Rp)'],
                  data: expenses.map((e) => [
                        e.title,
                        e.category,
                        DateFormat('dd-MM-yyyy').format(e.date),
                        e.amount.toStringAsFixed(0),
                      ]).toList(),
                ),
              ],
            );
          },
        ),
      );

      final pdfBytes = await pdf.save();
      await savePDF(pdfBytes, 'pengeluaran.pdf');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            kIsWeb
                ? 'PDF berhasil di-download di Web'
                : 'PDF berhasil disimpan di Mobile/Desktop',
          ),
          backgroundColor: Colors.indigo,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal export PDF: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
