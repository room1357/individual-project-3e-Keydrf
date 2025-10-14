import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart';
import 'edit_expense_screen.dart';
import 'category_screen.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final List<Expense> _expenses = [
    Expense(
      id: "1",
      title: "Makan Siang",
      description: "Nasi goreng",
      amount: 25000,
      category: "Makanan",
      date: DateTime.now(),
    ),
    Expense(
      id: "2",
      title: "Ojek Online",
      description: "Pergi ke kampus",
      amount: 15000,
      category: "Transportasi",
      date: DateTime.now(),
    ),
    Expense(
      id: "3",
      title: "Beli Pulsa",
      description: "Pulsa 20rb",
      amount: 20000,
      category: "Belanja",
      date: DateTime.now(),
    ),
  ];

  void _addExpense(Expense e) {
    setState(() => _expenses.add(e));
  }

  void _editExpense(Expense e) {
    setState(() {
      final index = _expenses.indexWhere((ex) => ex.id == e.id);
      if (index != -1) _expenses[index] = e;
    });
  }

  void _deleteExpense(String id) {
    setState(() {
      _expenses.removeWhere((e) => e.id == id);
    });
  }

  void _openAddExpense() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddExpenseScreen(onAdd: _addExpense),
      ),
    );
  }

  void _openEditExpense(Expense expense) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditExpenseScreen(
          existingExpense: expense,
          onEdit: _editExpense,
        ),
      ),
    );
  }

  void _openCategoryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CategoryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pengeluaran"),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: "Kelola Kategori",
            onPressed: _openCategoryScreen,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpense,
        child: const Icon(Icons.add),
      ),
      body: _expenses.isEmpty
          ? const Center(child: Text("Belum ada pengeluaran"))
          : ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final e = _expenses[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(e.title),
                    subtitle: Text("${e.category} • ${e.description}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Rp ${e.amount.toStringAsFixed(0)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          tooltip: "Edit",
                          onPressed: () => _openEditExpense(e),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: "Hapus",
                          onPressed: () => _showDeleteDialog(e),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showDeleteDialog(Expense e) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Pengeluaran"),
        content: Text("Apakah kamu yakin ingin menghapus '${e.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteExpense(e.id);
            },
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
