/// Dart client library for the Devin API.
///
/// This library provides a client for interacting with the Devin API.
library;

// Core
export 'src/devin_client.dart';
export 'src/core/api_exception.dart';

// Models
export 'src/models/session/session.dart';
export 'src/models/knowledge/knowledge.dart';
export 'src/models/secret/secret.dart';
export 'src/models/pagination/pagination.dart';

// Service interfaces
export 'src/services/base/base_service.dart';
export 'src/services/base/session_service_base.dart';
export 'src/services/base/knowledge_service_base.dart';
export 'src/services/base/secret_service_base.dart';
