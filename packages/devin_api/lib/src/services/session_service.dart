import 'package:meta/meta.dart';
import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../models/session/session.dart';
import '../models/pagination/pagination.dart';

/// Service for interacting with the Sessions API
/// API Documentation: https://docs.devin.ai/api-reference/sessions
class SessionService {
  /// The API client
  final DevinApiClient _apiClient;

  /// Creates a new [SessionService]
  SessionService({
    required DevinApiClient apiClient,
  }) : _apiClient = apiClient;

  /// Lists all sessions
  /// Endpoint: GET /api/sessions
  Future<PaginatedResponse<Session>> listSessions({
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

  /// Gets a session by ID
  /// Endpoint: GET /api/sessions/{id}
  Future<Session> getSession(String id) async {
    final response = await _apiClient.get('${DevinApiConstants.sessions}/$id');
    return Session.fromJson(response);
  }

  /// Creates a new session
  /// Endpoint: POST /api/sessions
  Future<Session> createSession(CreateSessionRequest request) async {
    final response = await _apiClient.post(
      DevinApiConstants.sessions,
      body: request.toJson(),
    );
    return Session.fromJson(response);
  }

  /// Deletes a session by ID
  /// Endpoint: DELETE /api/sessions/{id}
  Future<void> deleteSession(String id) async {
    await _apiClient.delete('${DevinApiConstants.sessions}/$id');
  }

  /// Sends a message to a session
  /// Endpoint: POST /api/sessions/{id}/messages
  Future<void> sendMessage(String sessionId, String message) async {
    await _apiClient.post(
      '${DevinApiConstants.sessions}/$sessionId/messages',
      body: {'content': message},
    );
  }
}
