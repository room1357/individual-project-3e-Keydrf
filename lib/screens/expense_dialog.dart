import 'package:flutter/material.dart';
import '../models/expense.dart';

Future<Expense?> showExpenseDialog({
  required BuildContext context,
  required List<String> categories,
  Expense? existingExpense,
}) {
  final titleController = TextEditingController(text: existingExpense?.title ?? '');
  final descController = TextEditingController(text: existingExpense?.description ?? '');
  final amountController =
      TextEditingController(text: existingExpense?.amount.toString() ?? '');
  String selectedCat = existingExpense?.category ?? categories.first;

  return showDialog<Expense>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(existingExpense == null ? 'Tambah Pengeluaran' : 'Edit Pengeluaran'),
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
              items: categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
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
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
        TextButton(
          onPressed: () {
            if (titleController.text.isEmpty || amountController.text.isEmpty) return;

            final newExpense = Expense(
              id: existingExpense?.id ?? DateTime.now().toString(),
              title: titleController.text,
              description: descController.text,
              category: selectedCat,
              amount: double.tryParse(amountController.text) ?? 0,
              date: existingExpense?.date ?? DateTime.now(),
            );

            Navigator.pop(context, newExpense);
          },
          child: const Text('Simpan'),
        ),
      ],
    ),
  );
}
