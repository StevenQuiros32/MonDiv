import 'package:flutter/foundation.dart';

import '../models/expense.dart';
import '../models/person.dart';

class AppState extends ChangeNotifier {
  static const String currency = '₡';
  static const double step = 500; // paso de redistribución en colones

  final List<Person> people = [];
  final List<Expense> expenses = [];

  int _uid = 1;
  int? editingExpenseId;

  // ---------------- Personas ----------------

  void addPerson(String name) {
    people.add(Person(id: _uid++, name: name));
    notifyListeners();
  }

  void removePerson(int id) {
    people.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // ---------------- Gastos ----------------

  void addExpense(String name, double amount) {
    expenses.add(Expense(id: _uid++, name: name, amount: amount, qty: 1));
    notifyListeners();
  }

  void updateExpense(int id, String name, double amount) {
    final expense = expenses.firstWhere((e) => e.id == id);
    expense.name = name;
    expense.amount = amount;
    notifyListeners();
  }

  void removeExpense(int id) {
    expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void changeExpenseQty(int id, int delta) {
    final expense = expenses.firstWhere((e) => e.id == id);
    final next = expense.qty + delta;
    if (next < 1) return;
    expense.qty = next;
    notifyListeners();
  }

  void startEditingExpense(int id) {
    editingExpenseId = id;
    notifyListeners();
  }

  void stopEditingExpense() {
    editingExpenseId = null;
    notifyListeners();
  }

  Expense? get expenseBeingEdited {
    if (editingExpenseId == null) return null;
    try {
      return expenses.firstWhere((e) => e.id == editingExpenseId);
    } catch (_) {
      return null;
    }
  }

  // ---------------- Cálculo exacto ----------------

  double get totalExpenses =>
      expenses.fold(0, (sum, e) => sum + e.lineTotal);

  void calculate() {
    final total = totalExpenses;
    final n = people.length;
    final base = n > 0 ? total / n : 0.0;
    for (final p in people) {
      p.amount = base;
    }
    notifyListeners();
  }

  double get totalRepartido => people.fold(0, (s, p) => s + p.amount);

  /// direction == 1: se le da más carga a esta persona (se quita a las demás)
  /// direction == -1: se le quita carga a esta persona (se reparte entre las demás)
  void adjustPerson(int id, int direction) {
    final n = people.length;
    if (n < 2) return;
    final person = people.firstWhere((p) => p.id == id);
    final others = people.where((p) => p.id != id).toList();

    if (direction == -1) {
      final s = step < person.amount ? step : person.amount;
      if (s <= 0) return;
      person.amount -= s;
      final share = s / others.length;
      for (final p in others) {
        p.amount += share;
      }
    } else {
      final totalAvailable = others.fold<double>(0, (sum, p) => sum + p.amount);
      final s = step < totalAvailable ? step : totalAvailable;
      if (s <= 0) return;
      final share = s / others.length;
      for (final p in others) {
        final take = share < p.amount ? share : p.amount;
        p.amount -= take;
      }
      person.amount += s;
    }
    notifyListeners();
  }

  // ---------------- Utilidades ----------------

  bool get canGoToExpenses => people.isNotEmpty;
  bool get canCalculate => expenses.isNotEmpty && people.isNotEmpty;

  static String formatMoney(num n) {
    final rounded = n.round();
    final isNegative = rounded < 0;
    final digits = rounded.abs().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      final remaining = digits.length - i;
      if (i > 0 && remaining % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    return '$currency${isNegative ? '-' : ''}$buffer';
  }
}
