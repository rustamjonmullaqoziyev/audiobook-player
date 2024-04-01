class Audio {
  Audio(
      {required this.id,
      required this.name,
      required this.url,
      required this.description,
      required this.position});

  final int id;
  final String name;
  final String url;
  final String description;
  final int position;

  factory Audio.fromJson(Map<String, dynamic> data) => Audio(
      id: data["audioId"],
      name: data["name"],
      url: data["url"],
      description: data["description"],
      position: data["position"]);
}
