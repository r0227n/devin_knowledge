/// Page information for paginated responses
class PageInfo {
  /// Creates a new [PageInfo]
  const PageInfo({
    required this.total,
    required this.limit,
    required this.page,
    required this.hasMore,
  });

  /// The total number of items
  final int total;

  /// The number of items per page
  final int limit;

  /// The current page number
  final int page;

  /// Whether there are more items
  final bool hasMore;

  /// Creates a [PageInfo] from JSON
  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      total: json['total'] as int,
      limit: json['limit'] as int,
      page: json['page'] as int,
      hasMore: json['has_more'] as bool,
    );
  }

  /// Converts this [PageInfo] to JSON
  Map<String, dynamic> toJson() {
    return {'total': total, 'limit': limit, 'page': page, 'has_more': hasMore};
  }
}

/// A paginated response
class PaginatedResponse<T> {
  /// Creates a new [PaginatedResponse]
  const PaginatedResponse({required this.items, required this.pageInfo});

  /// The list of items
  final List<T> items;

  /// The page information
  final PageInfo pageInfo;

  /// Creates a [PaginatedResponse] from JSON
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      items:
          (json['items'] as List<dynamic>)
              .map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList(),
      pageInfo: PageInfo.fromJson(json['page_info'] as Map<String, dynamic>),
    );
  }

  /// Converts this [PaginatedResponse] to JSON
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'items': items.map(toJsonT).toList(),
      'page_info': pageInfo.toJson(),
    };
  }
}
