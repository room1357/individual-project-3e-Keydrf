import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/expense.dart';
import 'expense_dialog.dart';
import 'export_screen.dart';
import 'statistics_screen.dart';

class AdvancedExpenseListScreen extends StatefulWidget {
  const AdvancedExpenseListScreen({super.key});

  @override
  State<AdvancedExpenseListScreen> createState() =>
      _AdvancedExpenseListScreenState();
}

class _AdvancedExpenseListScreenState extends State<AdvancedExpenseListScreen> {
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

  List<String> categories = [
    'Makanan',
    'Transportasi',
    'Hiburan',
    'Lainnya',
  ];
  String? _selectedCategory;
  String _sortBy = 'Tanggal';
  bool _isAscending = false;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
    _loadCategories();
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> data =
        _expenses.map((e) => jsonEncode(_expenseToMap(e))).toList();
    await prefs.setStringList('expenses', data);
  }

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('expenses');
    if (data != null) {
      setState(() {
        _expenses
          ..clear()
          ..addAll(
            data.map((e) => _mapToExpense(jsonDecode(e))).toList(),
          );
      });
    }
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('categories', categories);
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('categories');
    if (saved != null && saved.isNotEmpty) {
      setState(() {
        categories = saved;
      });
    }
  }

  Map<String, dynamic> _expenseToMap(Expense e) {
    return {
      'id': e.id,
      'title': e.title,
      'description': e.description,
      'amount': e.amount,
      'category': e.category,
      'date': e.date.toIso8601String(),
    };
  }

  Expense _mapToExpense(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      amount: (map['amount'] as num).toDouble(),
      category: map['category'],
      date: DateTime.parse(map['date']),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _expenses.add(expense);
    });
    _saveExpenses();
  }

  void _editExpense(Expense updatedExpense) {
    setState(() {
      final index = _expenses.indexWhere((e) => e.id == updatedExpense.id);
      if (index != -1) {
        _expenses[index] = updatedExpense;
      }
    });
    _saveExpenses();
  }

  void _deleteExpense(String id) {
    setState(() {
      _expenses.removeWhere((e) => e.id == id);
    });
    _saveExpenses();
  }

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
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Kelola Kategori'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < categories.length; i++)
                  ListTile(
                    title: Text(categories[i]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          iconSize: 20,
                          icon: const Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () {
                            final controller =
                                TextEditingController(text: categories[i]);
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Edit Kategori"),
                                content: TextField(
                                  controller: controller,
                                  decoration: const InputDecoration(
                                      labelText: 'Nama Kategori'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Batal"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final newName =
                                          controller.text.trim();
                                      if (newName.isNotEmpty) {
                                        setDialogState(() {
                                          categories[i] = newName;
                                        });
                                        _saveCategories();
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Update"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          iconSize: 20,
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            if (categories.length > 1) {
                              setDialogState(() {
                                categories.removeAt(i);
                              });
                              _saveCategories();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                TextField(
                  controller: newCategoryController,
                  decoration:
                      const InputDecoration(labelText: 'Kategori baru'),
                ),
              ],
            ),
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
                  setState(() {
                    categories.add(newCat);
                  });
                  _saveCategories();
                }
                Navigator.pop(context);
              },
              child: const Text('Tambah'),
            ),
          ],
        ),
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
        title: const Text(
          'Pengeluaran Lanjutan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.white),
            tooltip: 'Statistik',
            onPressed: _navigateToStatistics,
          ),
          IconButton(
            icon: const Icon(Icons.file_download, color: Colors.white),
            tooltip: 'Ekspor CSV',
            onPressed: _navigateToExport,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.indigo,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                DropdownButton<String>(
                  dropdownColor: Colors.indigo,
                  value: _selectedCategory,
                  hint: const Text(
                    'Filter kategori',
                    style: TextStyle(color: Colors.white),
                  ),
                  items: [
                    const DropdownMenuItem(
                        value: null,
                        child: Text('Semua',
                            style: TextStyle(color: Colors.white))),
                    ...categories.map(
                      (cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat,
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                  onChanged: (val) => setState(() => _selectedCategory = val),
                ),
                const Spacer(),
                DropdownButton<String>(
                  dropdownColor: Colors.indigo,
                  value: _sortBy,
                  items: ['Tanggal', 'Jumlah', 'Judul']
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            'Urut: $e',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _sortBy = val!),
                ),
                IconButton(
                  icon: Icon(
                    _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                    color: Colors.white,
                  ),
                  onPressed: () => setState(() => _isAscending = !_isAscending),
                ),
                IconButton(
                  icon: const Icon(Icons.category, color: Colors.white),
                  tooltip: 'Kelola Kategori',
                  onPressed: _openCategoryManager,
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredExpenses.isEmpty
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
                            backgroundColor: Colors.indigo.shade400,
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
                                      onPressed: () =>
                                          _openExpenseDialog(existingExpense: exp),
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
        foregroundColor: Colors.white,
        onPressed: () => _openExpenseDialog(),
        label: const Text('Tambah'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
