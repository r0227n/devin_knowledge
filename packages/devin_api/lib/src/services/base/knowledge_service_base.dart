import '../../models/knowledge/knowledge.dart';
import '../../models/pagination/pagination.dart';
import 'base_service.dart';

/// Abstract interface for interacting with the Knowledge API
/// API Documentation: https://docs.devin.ai/api-reference/knowledge
abstract class KnowledgeServiceBase extends BaseService<Knowledge, CreateKnowledgeRequest> {
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
