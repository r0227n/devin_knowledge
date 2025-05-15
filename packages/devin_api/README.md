# Devin API

A Dart client library for the Devin API.

## Features

- API key authentication
- Support for all Devin API endpoints
- Comprehensive error handling
- Manual JSON serialization/deserialization for data models
- Minimal external dependencies (only http package)

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  devin_api:
    path: ../packages/devin_api
```

## Usage

```dart
import 'package:devin_api/devin_api.dart';

void main() async {
  // Create a new DevinClient with your API key
  final client = DevinClient(apiKey: 'your-api-key');

  try {
    // List sessions
    final sessions = await client.sessions.listSessions();
    print('Sessions: ${sessions.items.length}');

    // Create a new session
    final newSession = await client.sessions.createSession(
      CreateSessionRequest(name: 'Test Session'),
    );
    print('Created session: ${newSession.id}');
  } on DevinApiException catch (e) {
    print('API error: ${e.message}');
  } finally {
    // Close the client
    client.close();
  }
}
```

## API Reference

### DevinClient

The main client for the Devin API.

```dart
final client = DevinClient(apiKey: 'your-api-key');
```

### Sessions

```dart
// List sessions
// GET /api/sessions
final sessions = await client.sessions.listSessions();

// Get a session by ID
// GET /api/sessions/{id}
final session = await client.sessions.getSession('session-id');

// Create a new session
// POST /api/sessions
final newSession = await client.sessions.createSession(
  CreateSessionRequest(name: 'Test Session'),
);

// Delete a session
// DELETE /api/sessions/{id}
await client.sessions.deleteSession('session-id');

// Send a message to a session
// POST /api/sessions/{id}/messages
await client.sessions.sendMessage('session-id', 'Hello, Devin!');
```

### Knowledge

```dart
// List knowledge items
// GET /api/knowledge
final knowledgeItems = await client.knowledge.listKnowledge();

// Get a knowledge item by ID
// GET /api/knowledge/{id}
final knowledgeItem = await client.knowledge.getKnowledge('knowledge-id');

// Create a new knowledge item
// POST /api/knowledge
final newKnowledge = await client.knowledge.createKnowledge(
  CreateKnowledgeRequest(
    title: 'Test Knowledge',
    content: 'This is a test knowledge item',
  ),
);

// Update a knowledge item
// PUT /api/knowledge/{id}
final updatedKnowledge = await client.knowledge.updateKnowledge(
  'knowledge-id',
  CreateKnowledgeRequest(
    title: 'Updated Knowledge',
    content: 'This is an updated knowledge item',
  ),
);

// Delete a knowledge item
// DELETE /api/knowledge/{id}
await client.knowledge.deleteKnowledge('knowledge-id');
```

### Secrets

```dart
// List secrets
// GET /api/secrets
final secrets = await client.secrets.listSecrets();

// Delete a secret
// DELETE /api/secrets/{id}
await client.secrets.deleteSecret('secret-id');
```

## Error Handling

The library throws a `DevinApiException` when an API error occurs:

```dart
try {
  // API call
} on DevinApiException catch (e) {
  print('API error: ${e.message}');
  print('Status code: ${e.statusCode}');
  print('Error code: ${e.errorCode}');
}
```

## Architecture

The library follows a layered architecture with:

- **Core**: Base API client and error handling
- **Models**: Data models for API entities
- **Services**: Service classes for each API endpoint category

This design promotes separation of concerns and makes the library easy to use and maintain.
