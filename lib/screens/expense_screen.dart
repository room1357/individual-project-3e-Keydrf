import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  List<Expense> expenses = [
    Expense(
      id: '1',
      title: 'Makan Siang',
      description: 'Nasi padang dan es teh',
      amount: 25000,
      category: 'Makanan',
      date: DateTime.now(),
    ),
    Expense(
      id: '2',
      title: 'Transportasi',
      description: 'Naik ojek online ke kampus',
      amount: 15000,
      category: 'Transportasi',
      date: DateTime.now(),
    ),
    Expense(
      id: '3',
      title: 'Kopi',
      description: 'Ngopi di kafe sore hari',
      amount: 30000,
      category: 'Hiburan',
      date: DateTime.now(),
    ),
  ];

  void _addExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
    });
  }

  void _editExpense(Expense updatedExpense) {
    setState(() {
      final index = expenses.indexWhere((e) => e.id == updatedExpense.id);
      if (index != -1) {
        expenses[index] = updatedExpense;
      }
    });
  }

  void _openAddExpense() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddExpenseScreen(
          onAdd: _addExpense,
        ),
      ),
    );
  }

  void _openEditExpense(Expense expense) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddExpenseScreen(
          onAdd: _editExpense,
          existingExpense: expense,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = expenses.fold(0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpense,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total Pengeluaran: Rp ${total.toStringAsFixed(0)}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final e = expenses[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        child: Text(
                          e.category[0].toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(e.title),
                      subtitle: Text("${e.category} • ${e.description}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Rp ${e.amount.toStringAsFixed(0)}"),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _openEditExpense(e),
                          ),
                        ],
                      ),
                    ),
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
