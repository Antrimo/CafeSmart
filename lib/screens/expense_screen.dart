import 'package:flutter/material.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final List<Map<String, dynamic>> _expenses = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void _addExpense() {
    final String title = _titleController.text;
    final double? amount = double.tryParse(_amountController.text);
    if (title.isNotEmpty && amount != null) {
      setState(() {
        _expenses.add({'title': title, 'amount': amount});
      });
      _titleController.clear();
      _amountController.clear();
    }
  }

  void _deleteExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Expense Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addExpense,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC02626),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Add Expense',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          _expenses[index]['title'][0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        _expenses[index]['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          '₹${_expenses[index]['amount'].toStringAsFixed(2)}'),
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
    );
  }
}
