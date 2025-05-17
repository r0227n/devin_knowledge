import 'knowledge.dart';
import 'secret.dart';
import 'session.dart';

/// A list response from the Devin API
class ListResponse<T> {
  const ListResponse({required this.items});

  /// The list of items
  final List<T> items;

  factory ListResponse.fromJson(Map<String, dynamic> json) {
    if (T == Session) {
      return ListResponse<Session>(
            items:
                (json['sessions'] as List<dynamic>)
                    .map((e) => Session.fromJson(e as Map<String, dynamic>))
                    .toList(),
          )
          as ListResponse<T>;
    } else if (T == Secret) {
      return ListResponse<Secret>(
            items:
                (json['secrets'] as List<dynamic>)
                    .map((e) => Secret.fromJson(e as Map<String, dynamic>))
                    .toList(),
          )
          as ListResponse<T>;
    } else if (T == KnowledgeResponse) {
      return ListResponse<KnowledgeResponse>(
            items: [KnowledgeResponse.fromJson(json)],
          )
          as ListResponse<T>;
    }

    throw ArgumentError.value(T, T.toString(), 'Unsupported type: $T');
  }
}
