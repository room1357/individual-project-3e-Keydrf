import 'package:intl/intl.dart';

class Expense {
  final String id;
  String title;
  String description;
  String category;
  double amount;
  DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.amount,
    required this.date,
  });

  String get formattedDate => DateFormat('dd MMM yyyy').format(date);
  String get formattedAmount => 'Rp ${amount.toStringAsFixed(0)}';
}
