import 'package:devin_api/devin_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../test_helpers/mock_client.dart';

void main() {
  setUpAll(() {
    registerFallbackValues();
  });
  
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
      
      // Setup mock HTTP client to return a response
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => mockResponse);
      when(() => mockHttpClient.post(any(), headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => mockResponse);
      when(() => mockHttpClient.put(any(), headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => mockResponse);
      when(() => mockHttpClient.delete(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => mockResponse);
    });

    group('list', () {
      test('returns a list of knowledge items', () async {
        // Arrange
        final responseJson = {
          'knowledge': [
            {
              'id': 'knowledge-1',
              'name': 'Test Knowledge 1',
              'body': 'Test Content 1',
              'trigger_description': 'When testing',
              'parent_folder_id': 'folder-1',
              'created_at': '2023-01-01T00:00:00Z',
            },
            {
              'id': 'knowledge-2',
              'name': 'Test Knowledge 2',
              'body': 'Test Content 2',
              'trigger_description': 'When testing',
              'parent_folder_id': 'folder-1',
              'created_at': '2023-01-03T00:00:00Z',
            },
          ],
          'folders': [
            {
              'id': 'folder-1',
              'name': 'Test Folder',
              'description': 'Test Folder Description',
              'created_at': '2023-01-01T00:00:00Z',
            }
          ]
        };

        when(() => mockResponse.body).thenReturn(jsonEncode(responseJson));

        // Act
        final result = await knowledgeService.list();

        // Assert
        expect(result.items.length, equals(1));
        expect(result.items[0].knowledge.length, equals(2));
        expect(result.items[0].knowledge[0].id, equals('knowledge-1'));
        expect(result.items[0].knowledge[0].name, equals('Test Knowledge 1'));
        expect(result.items[0].knowledge[0].body, equals('Test Content 1'));
        expect(result.items[0].knowledge[1].id, equals('knowledge-2'));
        expect(result.items[0].folders.length, equals(1));
        expect(result.items[0].folders[0].id, equals('folder-1'));

        verify(
          () => mockHttpClient.get(
            Uri.parse('${DevinApiConstants.baseUrl}/${DevinApiConstants.knowledge}'),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });
    });

    group('create', () {
      test('creates a new knowledge item', () async {
        // Arrange
        final request = CreateKnowledgeRequest(
          name: 'New Knowledge',
          body: 'New Content',
          triggerDescription: 'When testing',
        );
        final responseJson = {
          'id': 'new-knowledge',
          'name': 'New Knowledge',
          'body': 'New Content',
          'trigger_description': 'When testing',
          'parent_folder_id': null,
          'created_at': '2023-01-01T00:00:00Z',
        };

        when(() => mockResponse.body).thenReturn(jsonEncode(responseJson));

        // Act
        final result = await knowledgeService.create(request);

        // Assert
        expect(result.id, equals('new-knowledge'));
        expect(result.name, equals('New Knowledge'));
        expect(result.body, equals('New Content'));
        expect(result.triggerDescription, equals('When testing'));
        expect(
          result.createdAt,
          equals(DateTime.parse('2023-01-01T00:00:00Z')),
        );

        verify(
          () => mockHttpClient.post(
            Uri.parse('${DevinApiConstants.baseUrl}/${DevinApiConstants.knowledge}'),
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
          name: 'Updated Knowledge',
          body: 'Updated Content',
          triggerDescription: 'When testing updates',
        );
        final responseJson = {
          'id': 'knowledge-1',
          'name': 'Updated Knowledge',
          'body': 'Updated Content',
          'trigger_description': 'When testing updates',
          'parent_folder_id': null,
          'created_at': '2023-01-01T00:00:00Z',
        };

        when(() => mockResponse.body).thenReturn(jsonEncode(responseJson));

        // Act
        final result = await knowledgeService.update('knowledge-1', request);

        // Assert
        expect(result.id, equals('knowledge-1'));
        expect(result.name, equals('Updated Knowledge'));
        expect(result.body, equals('Updated Content'));
        expect(result.triggerDescription, equals('When testing updates'));
        expect(
          result.createdAt,
          equals(DateTime.parse('2023-01-01T00:00:00Z')),
        );

        verify(
          () => mockHttpClient.put(
            Uri.parse('${DevinApiConstants.baseUrl}/${DevinApiConstants.knowledge}/knowledge-1'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).called(1);
      });
    });

    group('delete', () {
      test('deletes a knowledge item by ID', () async {
        // Act
        await knowledgeService.delete('knowledge-1');

        // Assert
        verify(
          () => mockHttpClient.delete(
            Uri.parse('${DevinApiConstants.baseUrl}/${DevinApiConstants.knowledge}/knowledge-1'),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });
    });
  });
}
