import 'package:meta/meta.dart';
import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../models/knowledge/knowledge.dart';
import '../models/pagination/pagination.dart';

/// Service for interacting with the Knowledge API
/// API Documentation: https://docs.devin.ai/api-reference/knowledge
class KnowledgeService {
  /// The API client
  final DevinApiClient _apiClient;

  /// Creates a new [KnowledgeService]
  KnowledgeService({
    required DevinApiClient apiClient,
  }) : _apiClient = apiClient;

  /// Lists all knowledge items
  /// Endpoint: GET /api/knowledge
  Future<PaginatedResponse<Knowledge>> listKnowledge({
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

  /// Gets a knowledge item by ID
  /// Endpoint: GET /api/knowledge/{id}
  Future<Knowledge> getKnowledge(String id) async {
    final response = await _apiClient.get('${DevinApiConstants.knowledge}/$id');
    return Knowledge.fromJson(response);
  }

  /// Creates a new knowledge item
  /// Endpoint: POST /api/knowledge
  Future<Knowledge> createKnowledge(CreateKnowledgeRequest request) async {
    final response = await _apiClient.post(
      DevinApiConstants.knowledge,
      body: request.toJson(),
    );
    return Knowledge.fromJson(response);
  }

  /// Updates a knowledge item
  /// Endpoint: PUT /api/knowledge/{id}
  Future<Knowledge> updateKnowledge(
    String id,
    CreateKnowledgeRequest request,
  ) async {
    final response = await _apiClient.put(
      '${DevinApiConstants.knowledge}/$id',
      body: request.toJson(),
    );
    return Knowledge.fromJson(response);
  }

  /// Deletes a knowledge item by ID
  /// Endpoint: DELETE /api/knowledge/{id}
  Future<void> deleteKnowledge(String id) async {
    await _apiClient.delete('${DevinApiConstants.knowledge}/$id');
  }
}
