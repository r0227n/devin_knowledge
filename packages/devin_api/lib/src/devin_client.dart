import 'core/api_client.dart';
import 'services/session_service.dart';
import 'services/knowledge_service.dart';
import 'services/secret_service.dart';

/// The main client for the Devin API
class DevinClient {
  /// Creates a new [DevinClient]
  DevinClient({required String apiKey})
    : _apiClient = DevinApiClient(apiKey: apiKey) {
    _sessionService = SessionService(apiClient: _apiClient);
    _knowledgeService = KnowledgeService(apiClient: _apiClient);
    _secretService = SecretService(apiClient: _apiClient);
  }

  /// The API client
  final DevinApiClient _apiClient;

  /// The session service
  late final SessionService _sessionService;

  /// The knowledge service
  late final KnowledgeService _knowledgeService;

  /// The secret service
  late final SecretService _secretService;

  /// Gets the session service
  SessionService get sessions => _sessionService;

  /// Gets the knowledge service
  KnowledgeService get knowledge => _knowledgeService;

  /// Gets the secret service
  SecretService get secrets => _secretService;

  /// Closes the client
  void close() {
    _apiClient.close();
  }
}
