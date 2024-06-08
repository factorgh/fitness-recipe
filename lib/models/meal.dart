class Meal {
  const Meal(
      {required this.id,
      required this.imageUrl,
      required this.ingredients,
      required this.title});
  final String id;
  final String title;
  final List<String> ingredients;
  final String imageUrl;
  final bool isBookmarked = false;
}
