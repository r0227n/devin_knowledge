import 'core/api_client.dart';
import 'services/session_service.dart';
import 'services/knowledge_service.dart';
import 'services/secret_service.dart';

/// The main client for the Devin API
class DevinClient {
  /// The API client
  final DevinApiClient _apiClient;
  
  /// The session service
  late final SessionServiceBase _sessionService;
  
  /// The knowledge service
  late final KnowledgeServiceBase _knowledgeService;
  
  /// The secret service
  late final SecretServiceBase _secretService;
  
  /// Creates a new [DevinClient]
  DevinClient({
    required String apiKey,
  }) : _apiClient = DevinApiClient(apiKey: apiKey) {
    _sessionService = SessionService(apiClient: _apiClient);
    _knowledgeService = KnowledgeService(apiClient: _apiClient);
    _secretService = SecretService(apiClient: _apiClient);
  }
  
  /// Gets the session service
  SessionServiceBase get sessions => _sessionService;
  
  /// Gets the knowledge service
  KnowledgeServiceBase get knowledge => _knowledgeService;
  
  /// Gets the secret service
  SecretServiceBase get secrets => _secretService;
  
  /// Closes the client
  void close() {
    _apiClient.close();
  }
}
