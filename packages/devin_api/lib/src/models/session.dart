/// URL of the associated pull request
class PullRequest {
  const PullRequest({required this.url});

  /// URL of the associated pull request
  final Uri url;

  factory PullRequest.fromJson(Map<String, dynamic> json) {
    return PullRequest(url: Uri.parse(json['url'] as String));
  }

  Map<String, dynamic> toJson() {
    return {'url': url.toString()};
  }
}

/// A message from the session
class Message {
  const Message({
    required this.type,
    required this.message,
    required this.timestamp,
    this.username,
    this.origin,
  });

  /// The type of the message
  final String type;

  /// The content of the message
  final String message;

  /// Timestamp when the message was created
  final String timestamp;

  /// The username associated with the message
  final String? username;

  /// The origin of the message
  final String? origin;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      type: json['type'] as String,
      message: json['message'] as String,
      timestamp: json['timestamp'] as String,
      username: json['username'] as String?,
      origin: json['origin'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'message': message,
      'timestamp': timestamp,
      'username': username,
      'origin': origin,
    };
  }
}

/// Detail of the session
class Detail {
  const Detail({required this.detail});

  /// Detail of the session
  final String detail;

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(detail: json['detail'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'detail': detail};
  }
}

enum StatusEnum {
  running('RUNNING'),
  blocked('blocked'),
  stopped('stopped');

  const StatusEnum(this.key);

  final String key;

  factory StatusEnum.fromString(String value) {
    for (final status in StatusEnum.values) {
      if (status.key == value) {
        return status;
      }
    }

    throw ArgumentError('Invalid status: $value');
  }
}

/// A Devin session
class Session {
  const Session({
    required this.sessionId,
    required this.status,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.snapshotId,
    this.playbookId,
    this.tags,
    this.pullRequest,
    this.structuredOutput,
    this.statusEnum,
    this.messages,
  });

  /// Unique identifier for the session
  final String sessionId;

  /// Current status of the session
  final String status;

  /// Title or description of the sessionn
  final String title;

  /// Timestamp when the session was created
  final DateTime createdAt;

  /// Timestamp when the session was last updated
  final DateTime updatedAt;

  /// ID of the associated snapshot, if any
  final String? snapshotId;

  /// ID of the associated playbook, if any
  final String? playbookId;

  /// List of tags associated with the session
  final List<String>? tags;

  /// Pull request information, if any
  final PullRequest? pullRequest;

  /// Latest structured output value from events
  final String? structuredOutput;

  /// Latest status enum from status updates
  final StatusEnum? statusEnum;

  /// List of messages in the session
  final List<Message>? messages;

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionId: json['session_id'] as String,
      status: json['status'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      snapshotId: json['snapshot_id'] as String?,
      playbookId: json['playbook_id'] as String?,
      tags: json['tags'] as List<String>?,
      pullRequest:
          json['pull_request'] != null
              ? PullRequest.fromJson(
                json['pull_request'] as Map<String, dynamic>,
              )
              : null,
      structuredOutput: json['structured_output'] as String?,
      statusEnum:
          json['status_enum'] != null
              ? StatusEnum.fromString(json['status_enum'] as String)
              : null,
      messages:
          json['messages'] != null
              ? (json['messages'] as List<dynamic>)
                  .map((e) => Message.fromJson(e as Map<String, dynamic>))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'status': status,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'snapshot_id': snapshotId,
      'playbook_id': playbookId,
      'tags': tags,
      'pull_request': pullRequest?.toJson(),
      'structured_output': structuredOutput,
      'status_enum': statusEnum?.key,
      'messages': messages?.map((e) => e.toJson()).toList(),
    };
  }
}

/// Request to create a new session
class CreateSessionRequest {
  const CreateSessionRequest({
    required this.prompt,
    this.snapshotId,
    this.unlisted,
    this.idempotent,
    this.maxAcuLimit,
    this.secretIds,
    this.knowledgeIds,
    this.tags,
    this.title,
  });

  /// The task description for Devin
  final String prompt;

  /// ID of a machine snapshot to use
  final String? snapshotId;

  /// Whether the session should be unlisted
  final bool? unlisted;

  /// Enable idempotent session creation
  final bool? idempotent;

  /// Maximum ACU limit for the session
  final int? maxAcuLimit;

  /// List of secret IDs to use. If None, use all secrets. If empty list, use no secrets.
  final List<String>? secretIds;

  /// List of knowledge IDs to use. If None, use all knowledge. If empty list, use no knowledge.
  final List<String>? knowledgeIds;

  /// List of tags to add to the session.
  final List<String>? tags;

  /// Custom title for the session. If None, a title will be generated automatically.
  final String? title;

  factory CreateSessionRequest.fromJson(Map<String, dynamic> json) {
    return CreateSessionRequest(
      prompt: json['prompt'] as String,
      snapshotId: json['snapshot_id'] as String?,
      unlisted: json['unlisted'] as bool?,
      idempotent: json['idempotent'] as bool?,
      maxAcuLimit: json['max_acu_limit'] as int?,
      secretIds: json['secret_ids'] as List<String>?,
      knowledgeIds: json['knowledge_ids'] as List<String>?,
      tags: json['tags'] as List<String>?,
      title: json['title'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prompt': prompt,
      'snapshot_id': snapshotId,
      'unlisted': unlisted,
      'idempotent': idempotent,
      'max_acu_limit': maxAcuLimit,
      'secret_ids': secretIds,
      'knowledge_ids': knowledgeIds,
      'tags': tags,
      'title': title,
    };
  }
}
