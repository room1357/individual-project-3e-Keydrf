import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatelessWidget {
  final List<Expense> expenses;

  const StatisticsScreen({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final grouped = _groupExpensesByCategory(expenses);
    final total = grouped.values.fold(0.0, (a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Pengeluaran', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        
        elevation: 4,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kartu Ringkasan
            Card(
              elevation: 3,
              color: Colors.indigo,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan Pengeluaran',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Total: Rp ${NumberFormat('#,###').format(total)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Grafik Batang
            Expanded(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _getMaxY(grouped.values),
                      gridData:
                          FlGridData(show: true, horizontalInterval: 10000),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 45,
                            interval: 10000,
                            getTitlesWidget: (value, meta) => Text(
                              'Rp ${value ~/ 1000}K',
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.indigo),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final categories = grouped.keys.toList();
                              if (value.toInt() < categories.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    categories[value.toInt()],
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      barGroups: _buildBarGroups(grouped),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Keterangan Kategori
            Card(
              color: Colors.indigo,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: grouped.keys.map((category) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: _getCategoryColor(category),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, double> _groupExpensesByCategory(List<Expense> expenses) {
    final Map<String, double> grouped = {};
    for (var e in expenses) {
      grouped[e.category] = (grouped[e.category] ?? 0) + e.amount;
    }
    return grouped;
  }

  List<BarChartGroupData> _buildBarGroups(Map<String, double> grouped) {
    final categories = grouped.keys.toList();
    return List.generate(categories.length, (index) {
      final category = categories[index];
      final amount = grouped[category]!;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: amount,
            color: _getCategoryColor(category),
            width: 22,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      );
    });
  }

  double _getMaxY(Iterable<double> values) {
    if (values.isEmpty) return 100;
    final max = values.reduce((a, b) => a > b ? a : b);
    return (max / 10000).ceil() * 10000 + 10000;
  }

  // Warna kategori tetap beragam (warna-warni)
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Makanan':
        return Colors.orange;
      case 'Transportasi':
        return Colors.blue;
      case 'Utilitas':
        return Colors.green;
      case 'Hiburan':
        return Colors.purple;
      case 'Pendidikan':
        return Colors.red;
      case 'Kesehatan':
        return Colors.teal;
      case 'Lainnya':
        return Colors.pink;
      default:
        return Colors.indigo; // untuk kategori baru tetap indigo biar konsisten
    }
  }
}
