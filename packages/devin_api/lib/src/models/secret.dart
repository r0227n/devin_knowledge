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
    required this.secretId,
    required this.secretType,
    required this.secretName,
    required this.createdAt,
  });

  /// Unique identifier for the secret
  final String secretId;

  /// Type of secret
  final SecretType secretType;

  /// User-defined name for the secret
  final String secretName;

  /// Creation timestamp (ISO 8601)
  final DateTime createdAt;

  factory Secret.fromJson(Map<String, dynamic> data) {
    return Secret(
      secretId: data['secret_id'] as String,
      secretType: SecretType.fromString(data['secret_type'] as String),
      secretName: data['secret_name'] as String,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'secret_id': secretId,
      'secret_type': secretType.key,
      'secret_name': secretName,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
