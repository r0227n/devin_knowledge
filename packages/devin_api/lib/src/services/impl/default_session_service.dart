import '../../core/api_client.dart';
import '../../core/api_constants.dart';
import '../../models/session/session.dart';
import '../../models/pagination/pagination.dart';
import '../base/session_service_base.dart';

/// Default implementation of [SessionServiceBase]
/// API Documentation: https://docs.devin.ai/api-reference/sessions
class DefaultSessionService implements SessionServiceBase {
  /// The API client
  final DevinApiClient _apiClient;

  /// Creates a new [DefaultSessionService]
  DefaultSessionService({
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
