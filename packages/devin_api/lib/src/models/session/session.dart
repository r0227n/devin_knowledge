/// A Devin session
class Session {
  /// The ID of the session
  final String id;
  
  /// The name of the session
  final String name;
  
  /// The status of the session
  final String status;
  
  /// The timestamp when the session was created
  final DateTime createdAt;
  
  /// The timestamp when the session was last updated
  final DateTime updatedAt;
  
  /// Creates a new [Session]
  Session({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Creates a [Session] from JSON
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
  
  /// Converts this [Session] to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Request to create a new session
class CreateSessionRequest {
  /// The name of the session
  final String name;
  
  /// Creates a new [CreateSessionRequest]
  CreateSessionRequest({
    required this.name,
  });
  
  /// Creates a [CreateSessionRequest] from JSON
  factory CreateSessionRequest.fromJson(Map<String, dynamic> json) {
    return CreateSessionRequest(
      name: json['name'] as String,
    );
  }
  
  /// Converts this [CreateSessionRequest] to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
