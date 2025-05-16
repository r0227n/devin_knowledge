import 'package:devin_api/devin_api.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../test_helpers/mock_client.dart';

void main() {
  group('KnowledgeService', () {
    late MockHttpClient mockHttpClient;
    late MockResponse mockResponse;
    late DevinApiClient apiClient;
    late KnowledgeService knowledgeService;

    setUp(() {
      mockHttpClient = MockHttpClient();
      mockResponse = MockResponse();
      apiClient = DevinApiClient(
        apiKey: 'test-api-key',
        httpClient: mockHttpClient,
      );
      knowledgeService = KnowledgeService(apiClient: apiClient);

      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.body).thenReturn('{}');
    });

    group('list', () {
      test('returns a paginated list of knowledge items', () async {
        // Arrange
        final responseJson = {
          'items': [
            {
              'id': 'knowledge-1',
              'title': 'Test Knowledge 1',
              'content': 'Test Content 1',
              'created_at': '2023-01-01T00:00:00Z',
              'updated_at': '2023-01-02T00:00:00Z',
            },
            {
              'id': 'knowledge-2',
              'title': 'Test Knowledge 2',
              'content': 'Test Content 2',
              'created_at': '2023-01-03T00:00:00Z',
              'updated_at': '2023-01-04T00:00:00Z',
            },
          ],
          'page_info': {'total': 2, 'limit': 10, 'page': 1, 'has_more': false},
        };

        when(() => mockResponse.body).thenReturn(jsonEncode(responseJson));
        when(
          () => mockHttpClient.get(
            Uri.parse('https://api.devin.ai/api/knowledge?page=1&limit=10'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await knowledgeService.list(page: 1, limit: 10);

        // Assert
        expect(result.items.length, equals(2));
        expect(result.items[0].id, equals('knowledge-1'));
        expect(result.items[1].id, equals('knowledge-2'));
        expect(result.pageInfo.total, equals(2));
        expect(result.pageInfo.limit, equals(10));
        expect(result.pageInfo.page, equals(1));
        expect(result.pageInfo.hasMore, equals(false));

        verify(
          () => mockHttpClient.get(
            Uri.parse('https://api.devin.ai/api/knowledge?page=1&limit=10'),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });
    });

    group('get', () {
      test('returns a knowledge item by ID', () async {
        // Arrange
        final responseJson = {
          'id': 'knowledge-1',
          'title': 'Test Knowledge',
          'content': 'Test Content',
          'created_at': '2023-01-01T00:00:00Z',
          'updated_at': '2023-01-02T00:00:00Z',
        };

        when(() => mockResponse.body).thenReturn(jsonEncode(responseJson));
        when(
          () => mockHttpClient.get(
            Uri.parse('https://api.devin.ai/api/knowledge/knowledge-1'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await knowledgeService.get('knowledge-1');

        // Assert
        expect(result.id, equals('knowledge-1'));
        expect(result.title, equals('Test Knowledge'));
        expect(result.content, equals('Test Content'));
        expect(
          result.createdAt,
          equals(DateTime.parse('2023-01-01T00:00:00Z')),
        );
        expect(
          result.updatedAt,
          equals(DateTime.parse('2023-01-02T00:00:00Z')),
        );

        verify(
          () => mockHttpClient.get(
            Uri.parse('https://api.devin.ai/api/knowledge/knowledge-1'),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });
    });

    group('create', () {
      test('creates a new knowledge item', () async {
        // Arrange
        final request = CreateKnowledgeRequest(
          title: 'New Knowledge',
          content: 'New Content',
        );
        final responseJson = {
          'id': 'new-knowledge',
          'title': 'New Knowledge',
          'content': 'New Content',
          'created_at': '2023-01-01T00:00:00Z',
          'updated_at': '2023-01-01T00:00:00Z',
        };

        when(() => mockResponse.body).thenReturn(jsonEncode(responseJson));
        when(
          () => mockHttpClient.post(
            Uri.parse('https://api.devin.ai/api/knowledge'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await knowledgeService.create(request);

        // Assert
        expect(result.id, equals('new-knowledge'));
        expect(result.title, equals('New Knowledge'));
        expect(result.content, equals('New Content'));
        expect(
          result.createdAt,
          equals(DateTime.parse('2023-01-01T00:00:00Z')),
        );
        expect(
          result.updatedAt,
          equals(DateTime.parse('2023-01-01T00:00:00Z')),
        );

        verify(
          () => mockHttpClient.post(
            Uri.parse('https://api.devin.ai/api/knowledge'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).called(1);
      });
    });

    group('update', () {
      test('updates a knowledge item', () async {
        // Arrange
        final request = CreateKnowledgeRequest(
          title: 'Updated Knowledge',
          content: 'Updated Content',
        );
        final responseJson = {
          'id': 'knowledge-1',
          'title': 'Updated Knowledge',
          'content': 'Updated Content',
          'created_at': '2023-01-01T00:00:00Z',
          'updated_at': '2023-01-02T00:00:00Z',
        };

        when(() => mockResponse.body).thenReturn(jsonEncode(responseJson));
        when(
          () => mockHttpClient.put(
            Uri.parse('https://api.devin.ai/api/knowledge/knowledge-1'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await knowledgeService.update('knowledge-1', request);

        // Assert
        expect(result.id, equals('knowledge-1'));
        expect(result.title, equals('Updated Knowledge'));
        expect(result.content, equals('Updated Content'));
        expect(
          result.createdAt,
          equals(DateTime.parse('2023-01-01T00:00:00Z')),
        );
        expect(
          result.updatedAt,
          equals(DateTime.parse('2023-01-02T00:00:00Z')),
        );

        verify(
          () => mockHttpClient.put(
            Uri.parse('https://api.devin.ai/api/knowledge/knowledge-1'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).called(1);
      });
    });

    group('delete', () {
      test('deletes a knowledge item by ID', () async {
        // Arrange
        when(
          () => mockHttpClient.delete(
            Uri.parse('https://api.devin.ai/api/knowledge/knowledge-1'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await knowledgeService.delete('knowledge-1');

        // Assert
        verify(
          () => mockHttpClient.delete(
            Uri.parse('https://api.devin.ai/api/knowledge/knowledge-1'),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });
    });
  });
}
