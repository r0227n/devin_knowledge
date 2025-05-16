import 'base_service.dart';
import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../models/knowledge.dart';
import '../models/pagination.dart';

/// Knowledge Endpoints
/// API Documentation: https://docs.devin.ai/api-reference/overview#knowledge
class KnowledgeService
    implements BaseService<Knowledge, CreateKnowledgeRequest> {
  /// Creates a new [KnowledgeService]
  const KnowledgeService({required DevinApiClient apiClient})
    : _apiClient = apiClient;

  /// The API client
  final DevinApiClient _apiClient;

  @override
  /// Lists all knowledge items
  /// Endpoint: GET /api/knowledge
  Future<PaginatedResponse<Knowledge>> list({int? page, int? limit}) async {
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

  /// Updates a knowledge item
  /// Endpoint: PUT /api/knowledge/{id}
  Future<Knowledge> update(String id, CreateKnowledgeRequest request) async {
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
