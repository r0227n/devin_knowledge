import 'core/api_client.dart';
import 'services/base/session_service_base.dart';
import 'services/base/knowledge_service_base.dart';
import 'services/base/secret_service_base.dart';
import 'services/impl/default_session_service.dart';
import 'services/impl/default_knowledge_service.dart';
import 'services/impl/default_secret_service.dart';

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
    _sessionService = DefaultSessionService(apiClient: _apiClient);
    _knowledgeService = DefaultKnowledgeService(apiClient: _apiClient);
    _secretService = DefaultSecretService(apiClient: _apiClient);
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
