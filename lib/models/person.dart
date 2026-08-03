class Person {
  final int id;
  String name;
  double amount; // usado en la pantalla de Cálculo Exacto

  Person({
    required this.id,
    required this.name,
    this.amount = 0,
  });
}
