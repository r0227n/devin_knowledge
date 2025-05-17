/// A knowledge item
class Knowledge {
  /// Creates a new [Knowledge]
  const Knowledge({
    required this.id,
    required this.name,
    required this.body,
    required this.triggerDescription,
    required this.parentFolderId,
    required this.createdAt,
  });

  /// The id of the knowledge
  final String id;

  /// The name of the knowledge, used only for displaying the knowledge on the knowledge page
  final String name;

  /// The content of the knowledge. Devin will read this when the knowledge gets triggered
  final String body;

  /// The description of when this knowledge should be used by Devin
  final String triggerDescription;

  /// The id of the folder that this knowledge is located in. Null if the knowledge is not located in any folder
  final String? parentFolderId;

  /// Creation timestamp (ISO 8601)
  final DateTime createdAt;

  factory Knowledge.fromJson(Map<String, dynamic> json) {
    return Knowledge(
      id: json['id'] as String,
      name: json['name'] as String,
      body: json['body'] as String,
      triggerDescription: json['trigger_description'] as String,
      parentFolderId: json['parent_folder_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'body': body,
      'trigger_description': triggerDescription,
      'parent_folder_id': parentFolderId,
    };
  }
}

class Folder {
  const Folder({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  /// The id of the folder
  final String id;

  /// The name of the folder
  final String name;

  /// The description of the folder, assists the auto-organization of knowledge
  final String description;

  /// Creation timestamp (ISO 8601)
  final DateTime createdAt;

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Request to create a new knowledge item
class CreateKnowledgeRequest {
  const CreateKnowledgeRequest({
    required this.body,
    required this.name,
    required this.triggerDescription,
    this.parentFolderId,
  });

  /// The content of the knowledge. Devin will read this when the knowledge gets triggered
  final String body;

  /// The name of the knowledge, used only for displaying the knowledge on the knowledge page
  final String name;

  /// The description of when this knowledge should be used by Devin
  final String triggerDescription;

  /// The id of the folder that this knowledge is located in. Null if the knowledge is not located in any folder
  final String? parentFolderId;

  factory CreateKnowledgeRequest.fromJson(Map<String, dynamic> json) {
    return CreateKnowledgeRequest(
      body: json['body'] as String,
      name: json['name'] as String,
      triggerDescription: json['trigger_description'] as String,
      parentFolderId: json['parent_folder_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'body': body,
      'name': name,
      'trigger_description': triggerDescription,
      'parent_folder_id': parentFolderId,
    };
  }
}

class KnowledgeResponse {
  const KnowledgeResponse({required this.knowledge, required this.folders});

  /// List of all [Knowledge]
  final List<Knowledge> knowledge;

  /// List of all [Folder]
  final List<Folder> folders;

  factory KnowledgeResponse.fromJson(Map<String, dynamic> json) {
    return KnowledgeResponse(
      knowledge:
          (json['knowledge'] as List<dynamic>? ?? const <dynamic>[])
              .map((e) => Knowledge.fromJson(e as Map<String, dynamic>))
              .toList(),
      folders:
          (json['folders'] as List<dynamic>? ?? const <dynamic>[])
              .map((e) => Folder.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'knowledge': knowledge.map((e) => e.toJson()).toList(),
      'folders': folders.map((e) => e.toJson()).toList(),
    };
  }
}
