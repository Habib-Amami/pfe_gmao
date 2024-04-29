class Tool {
  final String name;
  final String description;
  final int quantity;
  bool isSelected;

  Tool({
    required this.name,
    required this.description,
    required this.quantity,
    this.isSelected = false,
  });

  @override
  String toString() {
    return 'Tool: {name: $name, description: $description, quantity: $quantity, isSelected: $isSelected}';
  }
}
