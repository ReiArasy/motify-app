class Quote {
  final String id;
  final String text;
  final String author;
  final String category;
  final String userId;

  Quote({
    required this.id,
    required this.text,
    required this.author,
    required this.category,
    required this.userId,
  });

  // Factory: convert data dari Supabase (Map) ke Quote
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      text: json['text'],
      author: json['author'],
      category: json['category'],
      userId: json['user_id'],
    );
  }
}
