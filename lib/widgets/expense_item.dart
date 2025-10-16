import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final IconData Function(String) getCategoryIcon;
  final Color Function(String) getCategoryColor;
  final VoidCallback onEdit;
  final VoidCallback onDismiss;
  final Function(Expense) showDeleteDialog;

  const ExpenseItem({
    super.key,
    required this.expense,
    required this.getCategoryIcon,
    required this.getCategoryColor,
    required this.onEdit,
    required this.onDismiss,
    required this.showDeleteDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(expense.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red.shade400,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        showDeleteDialog(expense);
        return false;
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: getCategoryColor(expense.category),
            child: Icon(
              getCategoryIcon(expense.category),
              color: Colors.white,
            ),
          ),
          title: Text(expense.title,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${expense.category} • ${expense.formattedDate}'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                expense.formattedAmount,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
