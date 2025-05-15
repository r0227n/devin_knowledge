/// A knowledge item
class Knowledge {
  /// The ID of the knowledge item
  final String id;
  
  /// The title of the knowledge item
  final String title;
  
  /// The content of the knowledge item
  final String content;
  
  /// The timestamp when the knowledge item was created
  final DateTime createdAt;
  
  /// The timestamp when the knowledge item was last updated
  final DateTime updatedAt;
  
  /// Creates a new [Knowledge]
  Knowledge({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Creates a [Knowledge] from JSON
  factory Knowledge.fromJson(Map<String, dynamic> json) {
    return Knowledge(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
  
  /// Converts this [Knowledge] to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Request to create a new knowledge item
class CreateKnowledgeRequest {
  /// The title of the knowledge item
  final String title;
  
  /// The content of the knowledge item
  final String content;
  
  /// Creates a new [CreateKnowledgeRequest]
  CreateKnowledgeRequest({
    required this.title,
    required this.content,
  });
  
  /// Creates a [CreateKnowledgeRequest] from JSON
  factory CreateKnowledgeRequest.fromJson(Map<String, dynamic> json) {
    return CreateKnowledgeRequest(
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }
  
  /// Converts this [CreateKnowledgeRequest] to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}
