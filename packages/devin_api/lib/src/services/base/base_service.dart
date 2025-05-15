import '../../models/pagination/pagination.dart';

/// Base service interface for common API operations
/// This interface defines methods common to all API services
abstract class BaseService<T, C> {
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
