import '../models/expense.dart';
import '/examples/looping_examples.dart';

void main() {
  List<Expense> expenses = [
  Expense(
    id: 'e1',
    title: 'Makan',
    description: 'Makan siang nasi goreng',
    amount: 50000,
    category: 'Food',
    date: DateTime.now(),
  ),
  Expense(
    id: 'e2',
    title: 'Ngopi',
    description: 'Kopi hitam di kafe',
    amount: 20000,
    category: 'Food',
    date: DateTime.now().subtract(Duration(days: 1)),
  ),
  Expense(
    id: 'e3',
    title: 'Transport',
    description: 'Naik ojek online',
    amount: 30000,
    category: 'Travel',
    date: DateTime.now().subtract(Duration(days: 2)),
  ),
];


  // 1. Hitung total
  print("Total (for trad): ${LoopingExamples.calculateTotalTraditional(expenses)}");
  print("Total (for-in): ${LoopingExamples.calculateTotalForIn(expenses)}");
  print("Total (forEach): ${LoopingExamples.calculateTotalForEach(expenses)}");
  print("Total (fold): ${LoopingExamples.calculateTotalFold(expenses)}");
  print("Total (reduce): ${LoopingExamples.calculateTotalReduce(expenses)}");

  // 2. Cari expense by id
  var found = LoopingExamples.findExpenseWhere(expenses, 'e2');
  print("Expense ditemukan: ${found?.title}");

  // 3. Filter by category
  var food = LoopingExamples.filterByCategoryWhere(expenses, 'food');
  print("Jumlah Food: ${food.length}");
}
