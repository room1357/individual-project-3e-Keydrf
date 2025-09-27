import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';
import '../models/category.dart';

class StorageService {
  static const String _expensesKey = "expenses";
  static const String _categoriesKey = "categories";

  // Simpan daftar expense
  static Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> expenseJson =
        expenses.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList(_expensesKey, expenseJson);
  }

  // Ambil daftar expense
  static Future<List<Expense>> loadExpenses(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_expensesKey) ?? [];
    return data.map((e) {
      final map = jsonDecode(e);
      return Expense.fromMap(map, categories);
    }).toList();
  }

  // Simpan kategori
  static Future<void> saveCategories(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> categoryJson =
        categories.map((c) => jsonEncode(c.toMap())).toList();
    await prefs.setStringList(_categoriesKey, categoryJson);
  }

  // Ambil kategori
  static Future<List<Category>> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_categoriesKey) ?? [];
    return data.map((c) => Category.fromMap(jsonDecode(c))).toList();
  }
}
