import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import 'expense_dialog.dart'; // ✅ dialog pop-up dipisahkan ke file baru
import 'export_screen.dart';
import 'statistics_screen.dart';

class AdvancedExpenseListScreen extends StatefulWidget {
  const AdvancedExpenseListScreen({super.key});

  @override
  State<AdvancedExpenseListScreen> createState() =>
      _AdvancedExpenseListScreenState();
}

class _AdvancedExpenseListScreenState extends State<AdvancedExpenseListScreen> {
  // ✅ Tambahkan data dummy agar langsung terlihat di awal
  final List<Expense> _expenses = [
    Expense(
      id: '1',
      title: 'Makan Siang',
      description: 'Nasi goreng + Es Teh',
      category: 'Makanan',
      amount: 25000,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Expense(
      id: '2',
      title: 'Ojek Online',
      description: 'Menuju kampus pagi hari',
      category: 'Transportasi',
      amount: 15000,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Expense(
      id: '3',
      title: 'Langganan Netflix',
      description: 'Pembayaran bulanan hiburan',
      category: 'Hiburan',
      amount: 54000,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Expense(
      id: '4',
      title: 'Pulsa Internet',
      description: 'Kuota 20GB untuk 30 hari',
      category: 'Lainnya',
      amount: 100000,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  final List<String> categories = [
    'Makanan',
    'Transportasi',
    'Hiburan',
    'Lainnya',
  ];
  String? _selectedCategory;
  String _sortBy = 'Tanggal';
  bool _isAscending = false;

  void _addExpense(Expense expense) {
    setState(() {
      _expenses.add(expense);
    });
  }

  void _editExpense(Expense updatedExpense) {
    setState(() {
      final index = _expenses.indexWhere((e) => e.id == updatedExpense.id);
      if (index != -1) {
        _expenses[index] = updatedExpense;
      }
    });
  }

  void _deleteExpense(String id) {
    setState(() {
      _expenses.removeWhere((e) => e.id == id);
    });
  }

  // 🔹 Dialog tambah/edit pengeluaran
  void _openExpenseDialog({Expense? existingExpense}) async {
    final result = await showExpenseDialog(
      context: context,
      categories: categories,
      existingExpense: existingExpense,
    );

    if (result != null) {
      if (existingExpense == null) {
        _addExpense(result);
      } else {
        _editExpense(result);
      }
    }
  }

  void _openCategoryManager() {
    final newCategoryController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Kelola Kategori'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final cat in categories)
                  ListTile(
                    title: Text(cat),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        if (categories.length > 1) {
                          setState(() {
                            categories.remove(cat);
                          });
                        }
                      },
                    ),
                  ),
                TextField(
                  controller: newCategoryController,
                  decoration: const InputDecoration(labelText: 'Kategori baru'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
              ElevatedButton(
                onPressed: () {
                  final newCat = newCategoryController.text.trim();
                  if (newCat.isNotEmpty && !categories.contains(newCat)) {
                    setState(() => categories.add(newCat));
                  }
                  Navigator.pop(context);
                },
                child: const Text('Tambah'),
              ),
            ],
          ),
    );
  }

  List<Expense> get _filteredExpenses {
    var list = [..._expenses];
    if (_selectedCategory != null) {
      list = list.where((e) => e.category == _selectedCategory).toList();
    }

    list.sort((a, b) {
      int compare;
      if (_sortBy == 'Tanggal') {
        compare = a.date.compareTo(b.date);
      } else if (_sortBy == 'Jumlah') {
        compare = a.amount.compareTo(b.amount);
      } else {
        compare = a.title.compareTo(b.title);
      }
      return _isAscending ? compare : -compare;
    });
    return list;
  }

  void _navigateToExport() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ExportScreen(expenses: _expenses)),
    );
  }

  void _navigateToStatistics() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StatisticsScreen(expenses: _expenses)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengeluaran Lanjutan'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Statistik',
            onPressed: _navigateToStatistics,
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Ekspor CSV',
            onPressed: _navigateToExport,
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔹 Filter & Sort
          Container(
            color: Colors.indigo.withOpacity(0.05),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: _selectedCategory,
                  hint: const Text('Filter kategori'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Semua')),
                    ...categories.map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    ),
                  ],
                  onChanged: (val) => setState(() => _selectedCategory = val),
                ),
                const Spacer(),
                DropdownButton<String>(
                  value: _sortBy,
                  items:
                      ['Tanggal', 'Jumlah', 'Judul']
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text('Urut: $e'),
                            ),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => _sortBy = val!),
                ),
                IconButton(
                  icon: Icon(
                    _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  ),
                  onPressed: () => setState(() => _isAscending = !_isAscending),
                ),
                IconButton(
                  icon: const Icon(Icons.category),
                  tooltip: 'Kelola Kategori',
                  onPressed: _openCategoryManager,
                ),
              ],
            ),
          ),

          // 🔹 List pengeluaran
          Expanded(
            child:
                _filteredExpenses.isEmpty
                    ? const Center(child: Text('Belum ada pengeluaran.'))
                    : ListView.builder(
                      itemCount: _filteredExpenses.length,
                      itemBuilder: (_, i) {
                        final exp = _filteredExpenses[i];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.indigo.shade300,
                              child: const Icon(
                                Icons.receipt_long,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              exp.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${exp.category} • ${dateFormat.format(exp.date)}\n${exp.description}',
                              style: const TextStyle(height: 1.3),
                            ),
                            isThreeLine: true,
                            trailing: SizedBox(
                              width: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    currencyFormat.format(exp.amount),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        iconSize: 20,
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blueAccent,
                                        ),
                                        onPressed:
                                            () => _openExpenseDialog(
                                              existingExpense: exp,
                                            ),
                                      ),
                                      const SizedBox(width: 4),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        iconSize: 20,
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () => _deleteExpense(exp.id),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        onPressed: () => _openExpenseDialog(),
        label: const Text('Tambah'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
