import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../models/session/session.dart';
import '../models/knowledge/knowledge.dart';
import '../models/secret/secret.dart';
import '../models/pagination/pagination.dart';

/// Base service interface for common API operations
/// This interface defines methods common to all API services
sealed class BaseService<T, C> {
  /// Lists all items with pagination
  /// 
  /// Parameters:
  ///   page: The page number (1-indexed)
  ///   limit: The number of items per page
  Future<PaginatedResponse<T>> list({
    int? page,
    int? limit,
  });
  
  /// Gets an item by ID
  /// 
  /// Parameters:
  ///   id: The ID of the item to get
  Future<T?> get(String id);
  
  /// Creates a new item
  /// 
  /// Parameters:
  ///   request: The request data for creating the item
  Future<T> create(C request);
  
  /// Deletes an item by ID
  /// 
  /// Parameters:
  ///   id: The ID of the item to delete
  Future<void> delete(String id);
}

/// Abstract interface for interacting with the Sessions API
/// API Documentation: https://docs.devin.ai/api-reference/sessions
sealed class SessionServiceBase extends BaseService<Session, CreateSessionRequest> {
  @override
  /// Lists all sessions
  /// Endpoint: GET /api/sessions
  Future<PaginatedResponse<Session>> list({
    int? page,
    int? limit,
  });

  @override
  /// Gets a session by ID
  /// Endpoint: GET /api/sessions/{id}
  Future<Session> get(String id);

  @override
  /// Creates a new session
  /// Endpoint: POST /api/sessions
  Future<Session> create(CreateSessionRequest request);

  @override
  /// Deletes a session by ID
  /// Endpoint: DELETE /api/sessions/{id}
  Future<void> delete(String id);

  /// Sends a message to a session
  /// Endpoint: POST /api/sessions/{id}/messages
  Future<void> sendMessage(String sessionId, String message);
}

/// Abstract interface for interacting with the Knowledge API
/// API Documentation: https://docs.devin.ai/api-reference/knowledge
sealed class KnowledgeServiceBase extends BaseService<Knowledge, CreateKnowledgeRequest> {
  @override
  /// Lists all knowledge items
  /// Endpoint: GET /api/knowledge
  Future<PaginatedResponse<Knowledge>> list({
    int? page,
    int? limit,
  });

  @override
  /// Gets a knowledge item by ID
  /// Endpoint: GET /api/knowledge/{id}
  Future<Knowledge> get(String id);

  @override
  /// Creates a new knowledge item
  /// Endpoint: POST /api/knowledge
  Future<Knowledge> create(CreateKnowledgeRequest request);

  @override
  /// Deletes a knowledge item by ID
  /// Endpoint: DELETE /api/knowledge/{id}
  Future<void> delete(String id);

  /// Updates a knowledge item
  /// Endpoint: PUT /api/knowledge/{id}
  Future<Knowledge> update(
    String id,
    CreateKnowledgeRequest request,
  );
}

/// Abstract interface for interacting with the Secrets API
/// API Documentation: https://docs.devin.ai/api-reference/secrets
sealed class SecretServiceBase extends BaseService<Secret, void> {
  @override
  /// Lists all secrets
  /// Endpoint: GET /api/secrets
  Future<PaginatedResponse<Secret>> list({
    int? page,
    int? limit,
  });

  @override
  /// Gets a secret by ID
  /// This method is not implemented in the API and will throw an error if called
  Future<Secret?> get(String id);

  @override
  /// Creates a new secret
  /// This method is not implemented in the API and will throw an error if called
  Future<Secret> create(void request);

  @override
  /// Deletes a secret by ID
  /// Endpoint: DELETE /api/secrets/{id}
  Future<void> delete(String id);
}

/// Implementation of [SessionServiceBase]
/// API Documentation: https://docs.devin.ai/api-reference/sessions
class SessionService implements SessionServiceBase {
  /// The API client
  final DevinApiClient _apiClient;

  /// Creates a new [SessionService]
  SessionService({
    required DevinApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  /// Lists all sessions
  /// Endpoint: GET /api/sessions
  Future<PaginatedResponse<Session>> list({
    int? page,
    int? limit,
  }) async {
    final response = await _apiClient.get(
      DevinApiConstants.sessions,
      queryParameters: {
        if (page != null) 'page': page.toString(),
        if (limit != null) 'limit': limit.toString(),
      },
    );

    return PaginatedResponse<Session>.fromJson(
      response,
      (json) => Session.fromJson(json),
    );
  }

  @override
  /// Gets a session by ID
  /// Endpoint: GET /api/sessions/{id}
  Future<Session> get(String id) async {
    final response = await _apiClient.get('${DevinApiConstants.sessions}/$id');
    return Session.fromJson(response);
  }

  @override
  /// Creates a new session
  /// Endpoint: POST /api/sessions
  Future<Session> create(CreateSessionRequest request) async {
    final response = await _apiClient.post(
      DevinApiConstants.sessions,
      body: request.toJson(),
    );
    return Session.fromJson(response);
  }

  @override
  /// Deletes a session by ID
  /// Endpoint: DELETE /api/sessions/{id}
  Future<void> delete(String id) async {
    await _apiClient.delete('${DevinApiConstants.sessions}/$id');
  }

  @override
  /// Sends a message to a session
  /// Endpoint: POST /api/sessions/{id}/messages
  Future<void> sendMessage(String sessionId, String message) async {
    await _apiClient.post(
      '${DevinApiConstants.sessions}/$sessionId/messages',
      body: {'content': message},
    );
  }
}

/// Implementation of [KnowledgeServiceBase]
/// API Documentation: https://docs.devin.ai/api-reference/knowledge
class KnowledgeService implements KnowledgeServiceBase {
  /// The API client
  final DevinApiClient _apiClient;

  /// Creates a new [KnowledgeService]
  KnowledgeService({
    required DevinApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  /// Lists all knowledge items
  /// Endpoint: GET /api/knowledge
  Future<PaginatedResponse<Knowledge>> list({
    int? page,
    int? limit,
  }) async {
    final response = await _apiClient.get(
      DevinApiConstants.knowledge,
      queryParameters: {
        if (page != null) 'page': page.toString(),
        if (limit != null) 'limit': limit.toString(),
      },
    );

    return PaginatedResponse<Knowledge>.fromJson(
      response,
      (json) => Knowledge.fromJson(json),
    );
  }

  @override
  /// Gets a knowledge item by ID
  /// Endpoint: GET /api/knowledge/{id}
  Future<Knowledge> get(String id) async {
    final response = await _apiClient.get('${DevinApiConstants.knowledge}/$id');
    return Knowledge.fromJson(response);
  }

  @override
  /// Creates a new knowledge item
  /// Endpoint: POST /api/knowledge
  Future<Knowledge> create(CreateKnowledgeRequest request) async {
    final response = await _apiClient.post(
      DevinApiConstants.knowledge,
      body: request.toJson(),
    );
    return Knowledge.fromJson(response);
  }

  @override
  /// Updates a knowledge item
  /// Endpoint: PUT /api/knowledge/{id}
  Future<Knowledge> update(
    String id,
    CreateKnowledgeRequest request,
  ) async {
    final response = await _apiClient.put(
      '${DevinApiConstants.knowledge}/$id',
      body: request.toJson(),
    );
    return Knowledge.fromJson(response);
  }

  @override
  /// Deletes a knowledge item by ID
  /// Endpoint: DELETE /api/knowledge/{id}
  Future<void> delete(String id) async {
    await _apiClient.delete('${DevinApiConstants.knowledge}/$id');
  }
}

/// Implementation of [SecretServiceBase]
/// API Documentation: https://docs.devin.ai/api-reference/secrets
class SecretService implements SecretServiceBase {
  /// The API client
  final DevinApiClient _apiClient;

  /// Creates a new [SecretService]
  SecretService({
    required DevinApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  /// Lists all secrets
  /// Endpoint: GET /api/secrets
  Future<PaginatedResponse<Secret>> list({
    int? page,
    int? limit,
  }) async {
    final response = await _apiClient.get(
      DevinApiConstants.secrets,
      queryParameters: {
        if (page != null) 'page': page.toString(),
        if (limit != null) 'limit': limit.toString(),
      },
    );

    return PaginatedResponse<Secret>.fromJson(
      response,
      (json) => Secret.fromJson(json),
    );
  }

  @override
  /// Gets a secret by ID
  /// This method is not implemented in the API and will throw an error if called
  Future<Secret?> get(String id) async => 
      throw UnimplementedError('Get secret is not implemented in the API');

  @override
  /// Creates a new secret
  /// This method is not implemented in the API and will throw an error if called
  Future<Secret> create(void request) async => 
      throw UnimplementedError('Create secret is not implemented in the API');

  @override
  /// Deletes a secret by ID
  /// Endpoint: DELETE /api/secrets/{id}
  Future<void> delete(String id) async {
    await _apiClient.delete('${DevinApiConstants.secrets}/$id');
  }
}
