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
            return {'title': data[0], 'amount': double.parse(data[1])};
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
                labelText: "Enter budget amount", fillColor: Colors.black),
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

  // Function to manually add to the budget
  void _addToBudget() {
    TextEditingController budgetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add to Budget"),
          content: TextField(
            controller: budgetController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Enter additional amount",
              fillColor: Colors.black,
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

  void deductExpense(String title, double amount) {
    if (amount <= _budget) {
      setState(() {
        _budget -= amount;
        _expenses.add({'title': title, 'amount': amount});
      });
      _saveBudget(_budget);
      _saveExpenses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Remaining Budget: ₹${_budget.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _expenses[index]['title'],
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      '₹${_expenses[index]['amount']}',
                      style: TextStyle(color: Colors.black),
                    ),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: _addToBudget,
        label: const Text(
          "Add Budget",
          style: TextStyle(color: Colors.black),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
