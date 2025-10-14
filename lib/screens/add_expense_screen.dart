import 'package:flutter/material.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  final Function(Expense) onAdd;
  final Expense? existingExpense; 

  const AddExpenseScreen({
    super.key,
    required this.onAdd,
    this.existingExpense, 
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ✅ isi field jika sedang edit
    if (widget.existingExpense != null) {
      _titleController.text = widget.existingExpense!.title;
      _descController.text = widget.existingExpense!.description;
      _amountController.text = widget.existingExpense!.amount.toString();
      _categoryController.text = widget.existingExpense!.category;
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final expense = Expense(
        id: widget.existingExpense?.id ?? DateTime.now().toString(),
        title: _titleController.text,
        description: _descController.text,
        amount: double.parse(_amountController.text),
        category: _categoryController.text,
        date: DateTime.now(),
      );

      widget.onAdd(expense);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingExpense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Pengeluaran" : "Tambah Pengeluaran"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Judul Pengeluaran"),
                validator: (value) =>
                    value!.isEmpty ? "Judul tidak boleh kosong" : null,
              ),
              TextFormField(
                controller: _descController,
                decoration:
                    const InputDecoration(labelText: "Deskripsi (opsional)"),
              ),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Jumlah (Rp)"),
                validator: (value) =>
                    value!.isEmpty ? "Masukkan jumlah" : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: "Kategori"),
                validator: (value) =>
                    value!.isEmpty ? "Kategori tidak boleh kosong" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(12),
                ),
                child: Text(
                  isEdit ? "Simpan Perubahan" : "Simpan Pengeluaran",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
