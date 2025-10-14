import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense existingExpense;
  final Function(Expense) onEdit;

  const EditExpenseScreen({
    super.key,
    required this.existingExpense,
    required this.onEdit,
  });

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _amountController;
  List<String> _categories = [];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingExpense.title);
    _descController = TextEditingController(text: widget.existingExpense.description);
    _amountController = TextEditingController(text: widget.existingExpense.amount.toString());
    _selectedCategory = widget.existingExpense.category;
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('categories');
    setState(() {
      _categories = saved ?? ['Makanan', 'Transportasi', 'Belanja'];
    });
  }

  void _save() {
    final edited = Expense(
      id: widget.existingExpense.id,
      title: _titleController.text,
      description: _descController.text,
      amount: double.parse(_amountController.text),
      category: _selectedCategory!,
      date: DateTime.now(),
    );
    widget.onEdit(edited);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Pengeluaran")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Judul"),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: "Deskripsi"),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Jumlah (Rp)"),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              hint: const Text("Pilih Kategori"),
              items: _categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              child: const Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }
}
