import '../../models/session/session.dart';
import '../../models/pagination/pagination.dart';
import 'base_service.dart';

/// Abstract interface for interacting with the Sessions API
/// API Documentation: https://docs.devin.ai/api-reference/sessions
abstract class SessionServiceBase extends BaseService<Session, CreateSessionRequest> {
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
