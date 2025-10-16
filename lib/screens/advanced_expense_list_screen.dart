import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'statistics_screen.dart'; // pastikan file ini sudah ada

class AdvancedExpenseListScreen extends StatefulWidget {
  const AdvancedExpenseListScreen({super.key});

  @override
  _AdvancedExpenseListScreenState createState() =>
      _AdvancedExpenseListScreenState();
}

class _AdvancedExpenseListScreenState extends State<AdvancedExpenseListScreen> {
  List<Expense> expenses = [
    Expense(
      id: '1',
      title: 'Makan Siang',
      description: 'Nasi goreng + es teh',
      category: 'Makanan',
      amount: 25000,
      date: DateTime.now(),
    ),
    Expense(
      id: '2',
      title: 'Ojek Online',
      description: 'Perjalanan ke kampus',
      category: 'Transportasi',
      amount: 15000,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Expense(
      id: '3',
      title: 'Streaming',
      description: 'Langganan bulanan',
      category: 'Hiburan',
      amount: 50000,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  List<String> categories = [
    'Makanan',
    'Transportasi',
    'Utilitas',
    'Hiburan',
    'Pendidikan',
  ];

  List<Expense> filteredExpenses = [];
  String selectedCategory = 'Semua';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredExpenses = expenses;
  }

  // 🔹 Filter pengeluaran
  void _filterExpenses() {
    setState(() {
      filteredExpenses =
          expenses.where((expense) {
            bool matchesSearch =
                searchController.text.isEmpty ||
                expense.title.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ) ||
                expense.description.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                );

            bool matchesCategory =
                selectedCategory == 'Semua' ||
                expense.category == selectedCategory;

            return matchesSearch && matchesCategory;
          }).toList();
    });
  }

  // 🔹 Tambah, edit, hapus pengeluaran
  void _addExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
      _filterExpenses();
    });
  }

  void _editExpense(Expense updatedExpense) {
    setState(() {
      final index = expenses.indexWhere((e) => e.id == updatedExpense.id);
      if (index != -1) {
        expenses[index] = updatedExpense;
        _filterExpenses();
      }
    });
  }

  void _deleteExpense(String id) {
    setState(() {
      expenses.removeWhere((e) => e.id == id);
      _filterExpenses();
    });
  }

  // 🔹 Dialog tambah/edit pengeluaran
  void _openExpenseDialog({Expense? existingExpense}) {
    final titleController = TextEditingController(
      text: existingExpense?.title ?? '',
    );
    final descController = TextEditingController(
      text: existingExpense?.description ?? '',
    );
    String selectedCat = existingExpense?.category ?? categories.first;
    final amountController = TextEditingController(
      text: existingExpense?.amount.toString() ?? '',
    );

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              existingExpense == null
                  ? 'Tambah Pengeluaran'
                  : 'Edit Pengeluaran',
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Judul'),
                  ),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedCat,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    items:
                        categories
                            .map(
                              (cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => selectedCat = val!,
                  ),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  if (titleController.text.isEmpty ||
                      amountController.text.isEmpty)
                    return;

                  if (existingExpense == null) {
                    _addExpense(
                      Expense(
                        id: DateTime.now().toString(),
                        title: titleController.text,
                        description: descController.text,
                        category: selectedCat,
                        amount: double.tryParse(amountController.text) ?? 0,
                        date: DateTime.now(),
                      ),
                    );
                  } else {
                    _editExpense(
                      Expense(
                        id: existingExpense.id,
                        title: titleController.text,
                        description: descController.text,
                        category: selectedCat,
                        amount: double.tryParse(amountController.text) ?? 0,
                        date: existingExpense.date,
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }

  // 🔹 Dialog manajemen kategori
  void _openCategoryManager() {
    final newCategoryController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Kelola Kategori"),
            content: StatefulBuilder(
              builder:
                  (context, setStateDialog) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: newCategoryController,
                        decoration: InputDecoration(
                          labelText: 'Tambah Kategori Baru',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              final newCat = newCategoryController.text.trim();
                              if (newCat.isNotEmpty &&
                                  !categories.contains(newCat)) {
                                setState(() {
                                  categories.add(newCat);
                                });
                                setStateDialog(() {});
                                newCategoryController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text("Daftar Kategori:"),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 200,
                        width: double.maxFinite,
                        child: ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final cat = categories[index];
                            return ListTile(
                              title: Text(cat),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {
                                      final controller = TextEditingController(
                                        text: cat,
                                      );
                                      showDialog(
                                        context: context,
                                        builder:
                                            (_) => AlertDialog(
                                              title: const Text(
                                                'Edit Kategori',
                                              ),
                                              content: TextField(
                                                controller: controller,
                                                decoration:
                                                    const InputDecoration(
                                                      labelText:
                                                          'Nama Kategori',
                                                    ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                  child: const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    final newName =
                                                        controller.text.trim();
                                                    if (newName.isNotEmpty) {
                                                      setState(() {
                                                        categories[index] =
                                                            newName;
                                                      });
                                                      Navigator.pop(context);
                                                      setStateDialog(() {});
                                                    }
                                                  },
                                                  child: const Text('Simpan'),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        categories.removeAt(index);
                                      });
                                      setStateDialog(() {});
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Tutup"),
              ),
            ],
          ),
    );
  }

  // 🔹 Navigasi ke halaman statistik
  void _openStatisticsScreen() {
    if (expenses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Belum ada data pengeluaran untuk ditampilkan.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatisticsScreen(expenses: expenses),
      ),
    );
  }

  // 🔹 Konfirmasi hapus
  void _showDeleteDialog(Expense expense) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Hapus Pengeluaran"),
            content: Text(
              "Apakah kamu yakin ingin menghapus '${expense.title}'?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _deleteExpense(expense.id);
                },
                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  // 🔹 UI utama
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengeluaran Advanced'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: 'Manajemen Kategori',
            onPressed: _openCategoryManager,
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Statistik Pengeluaran',
            onPressed: _openStatisticsScreen,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openExpenseDialog(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // 🔍 Pencarian
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Cari pengeluaran...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _filterExpenses(),
            ),
          ),

          // 🔹 Filter kategori
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children:
                  ['Semua', ...categories]
                      .map(
                        (category) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: selectedCategory == category,
                            onSelected: (selected) {
                              setState(() {
                                selectedCategory = category;
                                _filterExpenses();
                              });
                            },
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),

          // 🔹 Statistik ringkas
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Total', _calculateTotal(filteredExpenses)),
                _buildStatCard('Jumlah', '${filteredExpenses.length} item'),
                _buildStatCard(
                  'Rata-rata',
                  _calculateAverage(filteredExpenses),
                ),
              ],
            ),
          ),

          // 🔹 Daftar pengeluaran
          Expanded(
            child:
                filteredExpenses.isEmpty
                    ? const Center(child: Text('Tidak ada pengeluaran'))
                    : ListView.builder(
                      itemCount: filteredExpenses.length,
                      itemBuilder: (context, index) {
                        final expense = filteredExpenses[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getCategoryColor(
                                expense.category,
                              ),
                              child: Icon(
                                _getCategoryIcon(expense.category),
                                color: Colors.white,
                              ),
                            ),
                            title: Text(expense.title),
                            subtitle: Text(
                              '${expense.category} • ${expense.formattedDate}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  expense.formattedAmount,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[600],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed:
                                      () => _openExpenseDialog(
                                        existingExpense: expense,
                                      ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _showDeleteDialog(expense),
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
    );
  }

  // 🔹 Helper widget & fungsi
  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _calculateTotal(List<Expense> expenses) {
    double total = expenses.fold(0, (sum, e) => sum + e.amount);
    return 'Rp ${total.toStringAsFixed(0)}';
  }

  String _calculateAverage(List<Expense> expenses) {
    if (expenses.isEmpty) return 'Rp 0';
    double avg =
        expenses.fold(0.0, (sum, e) => sum + e.amount) / expenses.length;
    return 'Rp ${avg.toStringAsFixed(0)}';
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Makanan':
        return Icons.fastfood;
      case 'Transportasi':
        return Icons.directions_car;
      case 'Utilitas':
        return Icons.lightbulb;
      case 'Hiburan':
        return Icons.movie;
      case 'Pendidikan':
        return Icons.school;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Makanan':
        return Colors.orange;
      case 'Transportasi':
        return Colors.green;
      case 'Utilitas':
        return Colors.blue;
      case 'Hiburan':
        return Colors.purple;
      case 'Pendidikan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
