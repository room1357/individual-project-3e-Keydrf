import 'package:flutter/material.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  final Function(Expense) onAdd;

  const AddExpenseScreen({
    super.key,
    required this.onAdd,
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final expense = Expense(
        id: DateTime.now().toString(),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Pengeluaran"),
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
                decoration:
                    const InputDecoration(labelText: "Judul Pengeluaran"),
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
                decoration:
                    const InputDecoration(labelText: "Jumlah (Rp)"),
                validator: (value) =>
                    value!.isEmpty ? "Masukkan jumlah" : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration:
                    const InputDecoration(labelText: "Kategori"),
                validator: (value) =>
                    value!.isEmpty ? "Masukkan kategori" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(12),
                ),
                child: const Text(
                  "Simpan Pengeluaran",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
