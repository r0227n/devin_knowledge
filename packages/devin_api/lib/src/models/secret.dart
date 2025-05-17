/// Type of secret
enum SecretType {
  cookie('cookie'),
  keyValue('key-value'),
  dictionary('dictionary'),
  totp('totp');

  const SecretType(this.key);

  final String key;

  factory SecretType.fromString(String value) {
    for (final type in SecretType.values) {
      if (type.key == value) {
        return type;
      }
    }

    throw ArgumentError('Invalid secret type: $value');
  }
}

/// Secret Devin API Model
class Secret {
  const Secret({
    required this.id,
    required this.type,
    required this.key,
    required this.createdAt,
  });

  /// Unique identifier for the secret
  final String id;

  /// Type of secret
  final SecretType type;

  /// User-defined name for the secret
  final String key;

  /// Creation timestamp (ISO 8601)
  final DateTime createdAt;

  factory Secret.fromJson(Map<String, dynamic> data) {
    return Secret(
      id: data['id'] as String,
      type: SecretType.fromString(data['type'] as String),
      key: data['key'] as String,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'secret_id': id,
      'type': type.key,
      'key': key,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
