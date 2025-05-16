import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../models/session/session.dart';
import '../models/pagination/pagination.dart';

/// Base service interface for common API operations
/// This interface defines methods common to all API services
sealed class SessionBaseService<T, C> {
  /// Lists all items with pagination
  ///
  /// Parameters:
  ///   page: The page number (1-indexed)
  ///   limit: The number of items per page
  Future<PaginatedResponse<T>> list({int? page, int? limit});

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
sealed class SessionServiceBase
    extends SessionBaseService<Session, CreateSessionRequest> {
  @override
  /// Lists all sessions
  /// Endpoint: GET /api/sessions
  Future<PaginatedResponse<Session>> list({int? page, int? limit});

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

/// Implementation of [SessionServiceBase]
/// API Documentation: https://docs.devin.ai/api-reference/sessions
class SessionService implements SessionServiceBase {
  /// Creates a new [SessionService]
  const SessionService({required DevinApiClient apiClient})
    : _apiClient = apiClient;

  /// The API client
  final DevinApiClient _apiClient;

  @override
  /// Lists all sessions
  /// Endpoint: GET /api/sessions
  Future<PaginatedResponse<Session>> list({int? page, int? limit}) async {
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
