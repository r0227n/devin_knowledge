import 'knowledge.dart';
import 'secret.dart';
import 'session.dart';

/// A list response from the Devin API
class ListResponse<T> {
  const ListResponse({required this.items});

  /// The list of items
  final List<T> items;

  factory ListResponse.fromJson(Map<String, dynamic> json) {
    return ListResponse<T>(
      items:
          switch (T) {
                Session() =>
                  (json['sessions'] as List<dynamic>)
                      .map((e) => Session.fromJson(e as Map<String, dynamic>))
                      .toList(),
                Secret() =>
                  (json['secrets'] as List<dynamic>)
                      .map((e) => Secret.fromJson(e as Map<String, dynamic>))
                      .toList(),
                KnowledgeResponse() => KnowledgeResponse.fromJson(json),
                _ =>
                  throw ArgumentError.value(
                    T,
                    T.toString(),
                    'Unsupported type: $T',
                  ),
              }
              as List<T>,
    );
  }
}
