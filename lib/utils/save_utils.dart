// import 'dart:io';
// import 'dart:typed_data';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:open_filex/open_filex.dart';

// /// ===================== SAVE CSV =====================
// Future<void> saveCSV(String csv, String filename) async {
//   try {
//     // Minta izin penyimpanan di Android
//     await _requestStoragePermission();

//     // Tentukan direktori
//     final directory = await _getDownloadDirectory();
//     final path = '${directory.path}/$filename';

//     // Simpan file
//     final file = File(path);
//     await file.writeAsString(csv);

//     print('✅ CSV berhasil disimpan di: $path');
//     OpenFilex.open(path);
//   } catch (e) {
//     print('❌ Gagal menyimpan CSV: $e');
//   }
// }

// /// ===================== SAVE PDF =====================
// Future<void> savePDF(Uint8List pdfBytes, String filename) async {
//   try {
//     await _requestStoragePermission();

//     final directory = await _getDownloadDirectory();
//     final path = '${directory.path}/$filename';

//     final file = File(path);
//     await file.writeAsBytes(pdfBytes);

//     print('✅ PDF berhasil disimpan di: $path');
//     OpenFilex.open(path);
//   } catch (e) {
//     print('❌ Gagal menyimpan PDF: $e');
//   }
// }

// /// ===================== GET DOWNLOAD DIRECTORY =====================
// Future<Directory> _getDownloadDirectory() async {
//   Directory? directory;

//   if (Platform.isAndroid) {
//     // Biasanya di /storage/emulated/0/Download
//     directory = Directory('/storage/emulated/0/Download');
//     if (!await directory.exists()) {
//       directory = await getExternalStorageDirectory();
//     }
//   } else if (Platform.isIOS || Platform.isMacOS) {
//     directory = await getApplicationDocumentsDirectory();
//   } else if (Platform.isWindows || Platform.isLinux) {
//     directory = await getDownloadsDirectory();
//   } else {
//     directory = await getTemporaryDirectory();
//   }

//   return directory!;
// }

// /// ===================== REQUEST PERMISSION =====================
// Future<void> _requestStoragePermission() async {
//   if (Platform.isAndroid) {
//     final status = await Permission.storage.request();
//     if (!status.isGranted) {
//       throw Exception('Izin penyimpanan tidak diberikan');
//     }
//   }
// }
