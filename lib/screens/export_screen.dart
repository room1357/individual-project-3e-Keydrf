import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  Future<void> exportCSV(BuildContext context) async {
    // Contoh data dummy (bisa kamu ganti dari database atau API)
    final data = [
      ['Tanggal', 'Keterangan', 'Jumlah'],
      ['2025-10-21', 'Beli alat tulis', '50000'],
      ['2025-10-22', 'Biaya transport', '30000'],
    ];

    // Ubah ke format CSV
    String csvData = const ListToCsvConverter().convert(data);

    // Tentukan lokasi penyimpanan
    final directory = await getExternalStorageDirectory();
    final path = '${directory!.path}/data_pengeluaran.csv';

    // Tulis file
    final file = File(path);
    await file.writeAsString(csvData);

    // Notifikasi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('CSV berhasil diexport ke:\n$path'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> exportPDF(BuildContext context) async {
    final pdf = pw.Document();

    // Contoh data
    final data = [
      ['Tanggal', 'Keterangan', 'Jumlah'],
      ['2025-10-21', 'Beli alat tulis', '50000'],
      ['2025-10-22', 'Biaya transport', '30000'],
    ];

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Laporan Pengeluaran',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  )),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                data: data,
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.indigo,
                ),
                cellAlignment: pw.Alignment.centerLeft,
              ),
            ],
          );
        },
      ),
    );

    // Simpan ke file
    final directory = await getExternalStorageDirectory();
    final path = '${directory!.path}/data_pengeluaran.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    // Tampilkan notifikasi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF berhasil diexport ke:\n$path'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Opsional: Buka PDF langsung
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'data_pengeluaran.pdf');
  }

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
              onPressed: () async => await exportCSV(context),
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
              onPressed: () async => await exportPDF(context),
            ),
          ],
        ),
      ),
    );
  }
}
