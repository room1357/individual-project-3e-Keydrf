import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/category.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;
  final List<Category> categories;
  final Function(Expense) onEdit;

  const EditExpenseScreen({
    super.key,
    required this.expense,
    required this.categories,
    required this.onEdit,
  });

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _amountController;
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _descController = TextEditingController(text: widget.expense.description);
    _amountController =
        TextEditingController(text: widget.expense.amount.toString());
    _selectedCategory = widget.expense.category;
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final updatedExpense = Expense(
        id: widget.expense.id,
        title: _titleController.text,
        description: _descController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory!,
        date: widget.expense.date,
      );

      widget.onEdit(updatedExpense);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pengeluaran')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (value) =>
                    value!.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Jumlah tidak boleh kosong' : null,
              ),
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: widget.categories
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.name),
                        ))
                    .toList(),
                onChanged: (value) => setState(() {
                  _selectedCategory = value;
                }),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
