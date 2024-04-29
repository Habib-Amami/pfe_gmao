class SparePart {
  final String name;
  final String description;
  final int quantity;
  bool isSelected;

  SparePart({
    required this.name,
    required this.description,
    required this.quantity,
    this.isSelected = false,
  });

  @override
  String toString() {
    return 'SparePart{name: $name, description: $description, quantity: $quantity}';
  }
}
