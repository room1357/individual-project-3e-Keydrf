import 'category.dart';

class Expense {
  final String id;
  final String title;
  final String description;
  final double amount;
  final Category category; // Tetap Objek Category
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      // Disimpan sebagai ID String, bukan objek Category
      'categoryId': category.id, 
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map, List<Category> categories) {
    // Pastikan Anda mendapatkan categoryId sebagai String
    final String categoryId = map['categoryId'] as String;
    
    // Mencari objek Category yang sesuai berdasarkan ID
    final category = categories.firstWhere(
      (c) => c.id == categoryId,
      // Ini adalah mekanisme keamanan jika ID kategori tidak ditemukan
      orElse: () => Category(id: 'unknown', name: 'Unknown', icon: '❓'),
    );

    return Expense(
      // Melakukan casting eksplisit agar lebih aman saat membaca dari Map
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      // Hati-hati: jika 'amount' disimpan sebagai int di database, 
      // Anda mungkin perlu menggunakan .toDouble()
      amount: map['amount'] is int ? (map['amount'] as int).toDouble() : map['amount'] as double,
      category: category,
      // Pastikan data 'date' adalah String
      date: DateTime.parse(map['date'] as String),
    );
  }
}