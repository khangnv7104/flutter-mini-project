import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fl_chart/fl_chart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('expenses');
  runApp(const MyApp());
}

// Model chi tiêu
class Expense {
  final String name;
  final double amount;
  final String category;
  final DateTime date;

  Expense({required this.name, required this.amount, required this.category, required this.date});

  Map<String, dynamic> toMap() => {
    'name': name,
    'amount': amount,
    'category': category,
    'date': date.toIso8601String(),
  };

  static Expense fromMap(Map map) => Expense(
    name: map['name'],
    amount: map['amount'],
    category: map['category'],
    date: DateTime.parse(map['date']),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: const ExpenseHomePage(),
    );
  }
}

class ExpenseHomePage extends StatefulWidget {
  const ExpenseHomePage({super.key});
  @override
  State<ExpenseHomePage> createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Ăn uống';
  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = ['Ăn uống', 'Di chuyển', 'Mua sắm', 'Giải trí', 'Học tập', 'Khác'];

  void _addExpense() async {
    final name = _nameController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    if (name.isEmpty || amount <= 0) return;
    final expense = Expense(
      name: name,
      amount: amount,
      category: _selectedCategory,
      date: _selectedDate,
    );
    final box = Hive.box('expenses');
    await box.add(expense.toMap());
    _nameController.clear();
    _amountController.clear();
    setState(() {});
  }

  void _deleteExpense(int index) async {
    final box = Hive.box('expenses');
    await box.deleteAt(index);
    setState(() {});
  }

  List<Expense> _getExpenses() {
    final box = Hive.box('expenses');
    return box.values.map((e) => Expense.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  // Tổng chi tiêu theo danh mục
  Map<String, double> _getCategoryTotals(List<Expense> expenses) {
    final Map<String, double> totals = {};
    for (var cat in _categories) {
      totals[cat] = 0;
    }
    for (var e in expenses) {
      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
    }
    return totals;
  }

  // Tổng chi tiêu theo ngày
  Map<String, double> _getDayTotals(List<Expense> expenses) {
    final Map<String, double> totals = {};
    for (var e in expenses) {
      final day = "${e.date.day}/${e.date.month}";
      totals[day] = (totals[day] ?? 0) + e.amount;
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final expenses = _getExpenses();
    final categoryTotals = _getCategoryTotals(expenses);
    final dayTotals = _getDayTotals(expenses);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => _buildStats(categoryTotals, dayTotals),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Form nhập chi tiêu
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Tên chi tiêu'),
                ),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Số tiền'),
                ),
                Row(
                  children: [
                    DropdownButton<String>(
                      value: _selectedCategory,
                      items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      child: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) setState(() => _selectedDate = picked);
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _addExpense,
                  child: const Text('Thêm chi tiêu'),
                ),
              ],
            ),
          ),
          const Divider(),
          // Danh sách chi tiêu
          Expanded(
            child: expenses.isEmpty
                ? const Center(child: Text('Chưa có dữ liệu'))
                : ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final e = expenses[index];
                      return ListTile(
                        title: Text('${e.name} - ${e.amount.toStringAsFixed(0)}đ'),
                        subtitle: Text('${e.category} • ${e.date.day}/${e.date.month}/${e.date.year}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteExpense(index),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Widget thống kê
  Widget _buildStats(Map<String, double> categoryTotals, Map<String, double> dayTotals) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Biểu đồ chi tiêu theo danh mục', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: categoryTotals.entries
                      .where((e) => e.value > 0)
                      .map((e) => PieChartSectionData(
                            value: e.value,
                            title: e.key,
                            color: Colors.primaries[_categories.indexOf(e.key) % Colors.primaries.length],
                          ))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Biểu đồ chi tiêu theo ngày', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: dayTotals.entries
                      .map((e) => BarChartGroupData(
                            x: int.tryParse(e.key.split('/')[0]) ?? 0,
                            barRods: [
                              BarChartRodData(
                                toY: e.value,
                                color: Colors.blue,
                              ),
                            ],
                            showingTooltipIndicators: [0],
                          ))
                      .toList(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final day = value.toInt();
                          return Text('$day');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}