import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../core/api_exception.dart';
import '../models/session.dart';
import '../models/list_response.dart';

/// Abstract interface for interacting with the Sessions API
/// API Documentation: https://docs.devin.ai/api-reference/overview#sessions
sealed class SessionServiceBase {
  /// List all Devin sessions for your organization.
  ///
  /// [limit] - Maximum number of sessions to return per page
  /// [offset] - Number of sessions to skip for pagination
  /// [tags] - Filter sessions by tags
  Future<ListResponse<Session>> list({
    int limit = 100,
    int offset = 0,
    List<String> tags = const <String>[],
  });

  /// Create a new Devin session.
  /// You can optionally specify parameters like snapshot ID and session visibility.
  Future<Session> create(CreateSessionRequest request);

  /// Retrieve detailed information about an existing Devin session,
  /// including its status, output, and metadata.
  Future<Session> retrieve(String id);

  /// Send a message to an existing Devin session
  /// to provide additional instructions or information.
  Future<void> send(String sessionId, String message);

  // /// Upload files for Devin to work with during sessions.
  // /// Supports various file types including code, data, and documentation files.
  // Future<void> upload(String filePath);

  /// Update the tags associated with a Devin session.
  Future<Detail> updateTags(String id, List<String> tags);
}

/// Session Endpoints
/// API Documentation: https://docs.devin.ai/api-reference/overview#sessions
class SessionService implements SessionServiceBase {
  /// Creates a new [SessionService]
  const SessionService({required DevinApiClient apiClient})
    : _apiClient = apiClient;

  /// The API client
  final DevinApiClient _apiClient;

  @override
  Future<ListResponse<Session>> list({
    int limit = 100,
    int offset = 0,
    List<String> tags = const <String>[],
  }) async {
    final List<String> validatedArgs = [];

    if (limit < 1 || limit > 1000) {
      validatedArgs.add('Limit must be between 1 and 1000');
    }

    if (offset < 0) {
      validatedArgs.add('Offset must be greater than 0');
    }

    final message = validatedArgs.join(', ');
    if (message.isNotEmpty) {
      throw ArgumentError(message);
    }

    final response = await _apiClient.get(
      DevinApiConstants.sessions,
      queryParameters: {
        'limit': limit.toString(),
        'offset': offset.toString(),
        if (tags.isNotEmpty) 'tags': tags.join(','),
      },
    );

    if (response == null) {
      throw DevinApiException(
        statusCode: 404,
        message: 'No sessions found',
        errorCode: 'NO_SESSIONS_FOUND',
        response: null,
      );
    }

    return ListResponse<Session>.fromJson(response);
  }

  @override
  Future<Session> create(CreateSessionRequest request) async {
    final response = await _apiClient.post(
      DevinApiConstants.sessions,
      body: request.toJson(),
    );

    if (response == null) {
      throw DevinApiException(
        statusCode: 404,
        message: 'No session found',
        errorCode: 'NO_SESSION_FOUND',
        response: null,
      );
    }

    return Session.fromJson(response);
  }

  @override
  Future<Session> retrieve(String id) async {
    final response = await _apiClient.get('${DevinApiConstants.session}/$id');

    if (response == null) {
      throw DevinApiException(
        statusCode: 404,
        message: 'No session found',
        errorCode: 'NO_SESSION_FOUND',
        response: null,
      );
    }

    return Session.fromJson(response);
  }

  @override
  Future<void> send(String sessionId, String message) async {
    await _apiClient.post(
      '${DevinApiConstants.session}/$sessionId/message',
      body: {'message': message},
    );
  }

  // @override
  // Future<void> upload(String filePath) async {
  //   await _apiClient.post(
  //     DevinApiConstants.attachments,
  //     additionalHeaders: {'Content-Type': 'multipart/form-data'},
  //     body: {'file': filePath},
  //   );
  // }

  @override
  Future<Detail> updateTags(String id, List<String> tags) async {
    final response = await _apiClient.put(
      '${DevinApiConstants.session}/$id/tags',
      body: {'tags': tags},
    );

    if (response == null) {
      throw DevinApiException(
        statusCode: 404,
        message: 'No session found',
        errorCode: 'NO_SESSION_FOUND',
        response: null,
      );
    }

    return Detail.fromJson(response);
  }
}
