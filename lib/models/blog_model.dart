class Blog {
  String id;
  String imageUrl;
  String title;
  bool isFavorite;

  Blog({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.isFavorite = false,
  });
}
