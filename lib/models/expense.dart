class Expense {
  final int id;
  String name;
  double amount;
  int qty;

  Expense({
    required this.id,
    required this.name,
    required this.amount,
    this.qty = 1,
  });

  double get lineTotal => amount * qty;
}
