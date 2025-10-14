import 'package:flutter/material.dart';
import '../models/expense.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;
  final Function(Expense) onUpdate;

  const EditExpenseScreen({
    super.key,
    required this.expense,
    required this.onUpdate,
  });

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _amountController;
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _descController = TextEditingController(text: widget.expense.description);
    _amountController =
        TextEditingController(text: widget.expense.amount.toString());
    _categoryController = TextEditingController(text: widget.expense.category);
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      widget.expense.title = _titleController.text;
      widget.expense.description = _descController.text;
      widget.expense.amount = double.parse(_amountController.text);
      widget.expense.category = _categoryController.text;

      widget.onUpdate(widget.expense);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Pengeluaran"),
        backgroundColor: Colors.orange,
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
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.all(12),
                ),
                child: const Text(
                  "Simpan Perubahan",
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
