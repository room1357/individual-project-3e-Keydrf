import '../models/expense.dart';

class ExpenseManager {
  static List<Expense> expenses = [
    Expense(
      id: 'e1',
      title: 'Makan Siang',
      description: 'Nasi goreng + es teh',
      amount: 25000,
      category: 'Makanan',
      date: DateTime.now(),
    ),
    Expense(
      id: 'e2',
      title: 'Transportasi',
      description: 'Naik Gojek',
      amount: 15000,
      category: 'Transportasi',
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Expense(
      id: 'e3',
      title: 'Listrik PLN',
      description: 'Token listrik bulanan',
      amount: 200000,
      category: 'Utilitas',
      date: DateTime.now().subtract(Duration(days: 3)),
    ),
  ];

  static Map<String, double> getTotalByCategory(List<Expense> expenses) {
    Map<String, double> result = {};
    for (var expense in expenses) {
      result[expense.category] =
          (result[expense.category] ?? 0) + expense.amount;
    }
    return result;
  }

  static Expense? getHighestExpense(List<Expense> expenses) {
    if (expenses.isEmpty) return null;
    return expenses.reduce((a, b) => a.amount > b.amount ? a : b);
  }

  static List<Expense> getExpensesByMonth(List<Expense> expenses, int month, int year) {
    return expenses
        .where((expense) =>
            expense.date.month == month && expense.date.year == year)
        .toList();
  }

  static List<Expense> searchExpenses(List<Expense> expenses, String keyword) {
    String lowerKeyword = keyword.toLowerCase();
    return expenses
        .where((expense) =>
            expense.title.toLowerCase().contains(lowerKeyword) ||
            expense.description.toLowerCase().contains(lowerKeyword) ||
            expense.category.toLowerCase().contains(lowerKeyword))
        .toList();
  }

  static double getAverageDaily(List<Expense> expenses) {
    if (expenses.isEmpty) return 0;

    double total = expenses.fold(0, (sum, expense) => sum + expense.amount);

    Set<String> uniqueDays = expenses
        .map((expense) =>
            '${expense.date.year}-${expense.date.month}-${expense.date.day}')
        .toSet();

    return total / uniqueDays.length;
  }
}
