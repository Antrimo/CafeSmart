import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  List<Map<String, dynamic>> _expenses = [];
  double _budget = 0.0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBudgetAndExpenses();
  }

  Future<void> _loadBudgetAndExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _budget = prefs.getDouble('budget') ?? 0.0;
      _expenses = prefs.getStringList('expenses')?.map((e) {
            final data = e.split('|');
            final amountString = data[1].replaceAll(
                RegExp(r'[^0-9.]'), ''); // Remove non-numeric characters
            return {'title': data[0], 'amount': double.parse(amountString)};
          }).toList() ??
          [];
    });

    // Show popup if budget is not set
    if (_budget == 0.0) {
      Future.delayed(Duration.zero, _askForBudget);
    }
  }

  Future<void> _saveBudget(double budget) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('budget', budget);
  }

  Future<void> _saveExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'expenses',
        _expenses
            .map((e) => '${e['title']}|${e['amount'].toStringAsFixed(2)}')
            .toList());
  }

  void _askForBudget() {
    TextEditingController budgetController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Set Your Budget",
            style: TextStyle(color: Colors.black),
          ),
          content: TextField(
            controller: budgetController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Enter budget amount",
              labelStyle: TextStyle(color: Colors.black),
              filled: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                double? budget = double.tryParse(budgetController.text);
                if (budget != null && budget > 0) {
                  setState(() {
                    _budget = budget;
                  });
                  _saveBudget(budget);
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _addToBudget() {
    TextEditingController budgetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Add to Budget",
            style: TextStyle(color: Colors.black),
          ),
          content: TextField(
            controller: budgetController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Enter additional amount",
              labelStyle: TextStyle(color: Colors.black),
              filled: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                double? additionalAmount =
                    double.tryParse(budgetController.text);
                if (additionalAmount != null && additionalAmount > 0) {
                  setState(() {
                    _budget += additionalAmount;
                  });
                  _saveBudget(_budget);
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Add",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _addExpense() {
    final String title = _titleController.text;
    final double? amount = double.tryParse(_amountController.text);
    if (title.isNotEmpty && amount != null && amount <= _budget) {
      setState(() {
        _budget -= amount;
        _expenses.add({'title': title, 'amount': amount});
      });
      _saveBudget(_budget);
      _saveExpenses();
      _titleController.clear();
      _amountController.clear();
    }
  }

  void _deleteExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
    _saveExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Color(0xFFC02626),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                "Remaining Budget: ₹${_budget.toStringAsFixed(2)}",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      title: Text(
                        _expenses[index]['title'],
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '₹${_expenses[index]['amount']}',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteExpense(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xFFC02626),
        onPressed: _addToBudget,
        label: const Text(
          "Add Budget",
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
