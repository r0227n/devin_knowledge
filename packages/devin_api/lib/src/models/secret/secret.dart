/// A secret
class Secret {
  /// The ID of the secret
  final String id;
  
  /// The name of the secret
  final String name;
  
  /// The timestamp when the secret was created
  final DateTime createdAt;
  
  /// Creates a new [Secret]
  Secret({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  
  /// Creates a [Secret] from JSON
  factory Secret.fromJson(Map<String, dynamic> json) {
    return Secret(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
  
  /// Converts this [Secret] to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
