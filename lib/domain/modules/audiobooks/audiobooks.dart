class Audiobook {
  Audiobook(
      {required this.id,
      required this.name,
      required this.author,
      required this.description,
      required this.url,
      required this.imageUrl,
      required this.position});

  final int id;
  final String name;
  final String author;
  final String description;
  final String url;
  final String imageUrl;
  final int position;

  factory Audiobook.fromJson(Map<String, dynamic> data) => Audiobook(
      id: data["audiobookId"],
      name: data["name"],
      author: data["author"],
      description: data["description"],
      url: data["url"],
      imageUrl: data["imageUrl"],
      position: data["position"]);
}
