import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

class StatisticsScreen extends StatelessWidget {
  final List<Expense> expenses;

  const StatisticsScreen({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final totals = ExpenseService.getTotalByCategory(expenses);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistik Pengeluaran')),
      body: ListView(
        children: totals.entries
            .map((entry) => ListTile(
                  title: Text(entry.key),
                  trailing: Text('Rp ${entry.value.toStringAsFixed(0)}'),
                ))
            .toList(),
      ),
    );
  }
}
