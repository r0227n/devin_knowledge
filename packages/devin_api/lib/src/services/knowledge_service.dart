import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../models/knowledge/knowledge.dart';
import '../models/pagination/pagination.dart';

/// Base service interface for common API operations
/// This interface defines methods common to all API services
sealed class KnowledgeBaseService<T, C> {
  /// Lists all items with pagination
  /// 
  /// Parameters:
  ///   page: The page number (1-indexed)
  ///   limit: The number of items per page
  Future<PaginatedResponse<T>> list({
    int? page,
    int? limit,
  });
  
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

/// Abstract interface for interacting with the Knowledge API
/// API Documentation: https://docs.devin.ai/api-reference/knowledge
sealed class KnowledgeServiceBase extends KnowledgeBaseService<Knowledge, CreateKnowledgeRequest> {
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

/// Implementation of [KnowledgeServiceBase]
/// API Documentation: https://docs.devin.ai/api-reference/knowledge
class KnowledgeService implements KnowledgeServiceBase {
  /// The API client
  final DevinApiClient _apiClient;

  /// Creates a new [KnowledgeService]
  KnowledgeService({
    required DevinApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  /// Lists all knowledge items
  /// Endpoint: GET /api/knowledge
  Future<PaginatedResponse<Knowledge>> list({
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

  @override
  /// Updates a knowledge item
  /// Endpoint: PUT /api/knowledge/{id}
  Future<Knowledge> update(
    String id,
    CreateKnowledgeRequest request,
  ) async {
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
