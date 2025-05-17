import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../core/api_exception.dart';
import '../models/knowledge.dart';
import '../models/list_response.dart';

/// Abstract interface for interacting with the Knowledge API
/// API Documentation: https://docs.devin.ai/api-reference/overview#knowledge
sealed class KnowledgeServiceBase {
  /// Gets all knowledge and folders in your current organization.
  /// This endpoint will not return system knowledge
  /// (repo indexes or built-in knowledge) managed by Cognition.
  Future<ListResponse<KnowledgeResponse>> list();

  /// Create a new piece of knowledge.
  Future<Knowledge> create(CreateKnowledgeRequest data);

  /// Update the name, body, or trigger of a piece of knowledge.
  Future<Knowledge> update(String id, CreateKnowledgeRequest data);

  /// Permanently delete a piece of knowledge by its ID. This action cannot be undone.
  Future<void> delete(String id);
}

/// Knowledge Endpoints
/// API Documentation: https://docs.devin.ai/api-reference/overview#knowledge
class KnowledgeService implements KnowledgeServiceBase {
  /// Creates a new [KnowledgeService]
  const KnowledgeService({required DevinApiClient apiClient})
    : _apiClient = apiClient;

  /// The API client
  final DevinApiClient _apiClient;

  @override
  Future<ListResponse<KnowledgeResponse>> list() async {
    final response = await _apiClient.get(DevinApiConstants.knowledge);

    if (response == null) {
      throw DevinApiException(
        statusCode: 404,
        message: 'No knowledge found',
        errorCode: 'NO_KNOWLEDGE_FOUND',
        response: null,
      );
    }

    return ListResponse<KnowledgeResponse>.fromJson(response);
  }

  @override
  Future<Knowledge> create(CreateKnowledgeRequest request) async {
    final response = await _apiClient.post(
      DevinApiConstants.knowledge,
      body: request.toJson(),
    );

    if (response == null) {
      throw DevinApiException(
        statusCode: 404,
        message: 'No knowledge found',
        errorCode: 'NO_KNOWLEDGE_FOUND',
        response: null,
      );
    }
    return Knowledge.fromJson(response);
  }

  @override
  Future<Knowledge> update(String id, CreateKnowledgeRequest request) async {
    final response = await _apiClient.put(
      '${DevinApiConstants.knowledge}/$id',
      body: request.toJson(),
    );

    if (response == null) {
      throw DevinApiException(
        statusCode: 404,
        message: 'No knowledge found',
        errorCode: 'NO_KNOWLEDGE_FOUND',
        response: null,
      );
    }

    return Knowledge.fromJson(response);
  }

  @override
  Future<void> delete(String id) async {
    await _apiClient.delete('${DevinApiConstants.knowledge}/$id');
  }
}
