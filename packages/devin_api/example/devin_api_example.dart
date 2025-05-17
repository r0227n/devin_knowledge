import 'package:devin_api/devin_api.dart';

void main() async {
  // Create a new DevinClient with your API key
  final client = DevinClient(apiKey: 'your-api-key');

  try {
    // List sessions
    final sessions = await client.sessions.list();
    print('Sessions: ${sessions.items.length}');

    // Create a new session
    final newSession = await client.sessions.create(
      CreateSessionRequest(name: 'Test Session'),
    );
    print('Created session: ${newSession.id}');

    // List knowledge items
    final knowledgeItems = await client.knowledge.list();
    print('Knowledge items: ${knowledgeItems.items.length}');

    // Create a new knowledge item
    final newKnowledge = await client.knowledge.create(
      CreateKnowledgeRequest(
        name: 'Test Knowledge',
        body: 'This is a test knowledge item',
        triggerDescription: 'Triggered by example script',
      ),
    );
    print('Created knowledge item: ${newKnowledge.id}');

    // List secrets
    final secrets = await client.secrets.list();
    print('Secrets: ${secrets.items.length}');
  } on DevinApiException catch (e) {
    print('API error: ${e.message}');
  } finally {
    // Close the client
    client.close();
  }
}
