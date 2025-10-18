class MealEntity {
  final String name;
  final String description;
  final double price;
  final List<String> dietTags;

  const MealEntity({
    required this.name,
    required this.description,
    required this.price,
    required this.dietTags,
  });
}
