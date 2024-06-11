
class Query {
  final List<dynamic> items;

  const Query({required this.items});
  factory Query.fromJson(Map<String, dynamic> json) {
    return Query(
      items: json['Items'] as List<dynamic>,
    );
  }
}
