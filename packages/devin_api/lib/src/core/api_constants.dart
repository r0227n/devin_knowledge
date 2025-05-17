/// API constants for the Devin API
class DevinApiConstants {
  static const String _apiVersion = 'v1';

  /// The base URL for the Devin API
  /// https://docs.devin.ai/api-reference/overview
  static const String baseUrl = 'https://api.devin.ai';

  /// The header key for the API key
  static const String authHeaderKey = 'Authorization';

  /// The header value prefix for the API key
  static const String authHeaderValuePrefix = 'Bearer ';

  /// API endpoints
  /// GET /api/sessions - List all sessions
  /// POST /api/sessions - Create a new session
  /// GET /api/sessions/{id} - Get a session by ID
  /// DELETE /api/sessions/{id} - Delete a session
  /// POST /api/sessions/{id}/messages - Send a message to a session
  static const String sessions = '$_apiVersion/sessions';

  static const String session = '$_apiVersion/session';

  static const String attachments = '$_apiVersion/attachments';

  /// GET /api/secrets - List all secrets
  /// DELETE /api/secrets/{id} - Delete a secret
  static const String secrets = '$_apiVersion/secrets';

  /// GET /api/knowledge - List all knowledge items
  /// POST /api/knowledge - Create a new knowledge item
  /// GET /api/knowledge/{id} - Get a knowledge item by ID
  /// PUT /api/knowledge/{id} - Update a knowledge item
  /// DELETE /api/knowledge/{id} - Delete a knowledge item
  static const String knowledge = '$_apiVersion/knowledge';

  /// Enterprise API endpoints
  static const String enterprise = '$_apiVersion/enterprise';

  /// Error messages
  static const String invalidApiKey = 'Invalid API key provided';
  static const String networkError = 'Network error occurred';
  static const String serverError = 'Server error occurred';
  static const String unknownError = 'Unknown error occurred';
}
