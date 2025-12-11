
class Order {
  final String id;
  final String customerName;
  final String status;
  final double amount;
  final DateTime date;

  Order({
    required this.id,
    required this.customerName,
    required this.status,
    required this.amount,
    required this.date,
  });
}
