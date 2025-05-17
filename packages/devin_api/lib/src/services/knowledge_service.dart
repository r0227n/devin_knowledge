import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../models/knowledge.dart';
import '../models/list_response.dart';

/// Knowledge Endpoints
/// API Documentation: https://docs.devin.ai/api-reference/overview#knowledge
class KnowledgeService {
  /// Creates a new [KnowledgeService]
  const KnowledgeService({required DevinApiClient apiClient})
    : _apiClient = apiClient;

  /// The API client
  final DevinApiClient _apiClient;

  /// Lists all knowledge items
  /// Endpoint: GET /api/knowledge
  Future<ListResponse<KnowledgeResponse>> list() async {
    final response = await _apiClient.get(DevinApiConstants.knowledge);

    return ListResponse<KnowledgeResponse>.fromJson(response);
  }

  /// Creates a new knowledge item
  /// Endpoint: POST /api/knowledge
  Future<Knowledge> create(CreateKnowledgeRequest data) async {
    final response = await _apiClient.post(
      DevinApiConstants.knowledge,
      body: data.toJson(),
    );

    return Knowledge.fromJson(response);
  }

  /// Updates a knowledge item
  /// Endpoint: PUT /api/knowledge/{id}
  Future<Knowledge> update(String id, CreateKnowledgeRequest data) async {
    final response = await _apiClient.put(
      '${DevinApiConstants.knowledge}/$id',
      body: data.toJson(),
    );

    return Knowledge.fromJson(response);
  }

  /// Deletes a knowledge item by ID
  /// Endpoint: DELETE /api/knowledge/{id}
  Future<void> delete(String id) async {
    await _apiClient.delete('${DevinApiConstants.knowledge}/$id');
  }
}
