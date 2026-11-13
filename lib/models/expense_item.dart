class ExpenseItem {
  final int id;
  final String title;
  final double price;
  final DateTime date;

  ExpenseItem({
    required this.id,
    required this.title,
    required this.price,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'date': date.toIso8601String(),
    };
  }
}