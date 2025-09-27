import '../models/expense.dart';

class ExpenseService {
  static Map<String, double> getTotalByCategory(List<Expense> expenses) {
    Map<String, double> result = {};
    for (var expense in expenses) {
      result[expense.category.name] =
          (result[expense.category.name] ?? 0) + expense.amount;
    }
    return result;
  }

  static double getTotal(List<Expense> expenses) {
    return expenses.fold(0, (sum, e) => sum + e.amount);
  }
}
