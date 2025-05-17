# Dart MCP Server Implementation Guide

## Table of Contents

1. [What is MCP](#what-is-mcp)
2. [Prerequisites](#prerequisites)
3. [Basic MCP Server Implementation](#basic-mcp-server-implementation)
4. [Extending Server Capabilities](#extending-server-capabilities)
5. [Communication with Clients](#communication-with-clients)
6. [Advanced Implementation Examples](#advanced-implementation-examples)
7. [Troubleshooting](#troubleshooting)

## What is MCP

MCP (Machine Communication Protocol) is a protocol designed to standardize communication between AI models and tools. By using MCP, AI models can access various tools and resources to perform more complex tasks.

In Dart, you can implement MCP servers and clients using the `dart_mcp` package. This guide explains how to create a custom MCP server using Dart.

## Prerequisites

To implement an MCP server, you need:

- Dart SDK (2.19.0 or higher)
- The `dart_mcp` package

Add the following dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  dart_mcp: ^0.1.0  # Check for the latest version
  stream_channel: ^2.1.0
  async: ^2.10.0
```

## Basic MCP Server Implementation

### 1. Creating a Basic Server Class

To implement an MCP server, extend the `MCPServer` class:

```dart
import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:async/async.dart';
import 'package:dart_mcp/server.dart';
import 'package:stream_channel/stream_channel.dart';

/// A basic MCP server implementation
class MyMCPServer extends MCPServer {
  MyMCPServer(super.channel)
    : super.fromStreamChannel(
        implementation: ServerImplementation(
          name: 'My MCP Server',
          version: '0.1.0',
        ),
        instructions: 'This is a basic example of an MCP server.',
      );

  @override
  FutureOr<InitializeResult> initialize(InitializeRequest request) {
    // Server initialization logic goes here
    return super.initialize(request);
  }
}
```

### 2. Starting the Server

Create a main function to start the server:

```dart
void main() {
  MyMCPServer(
    StreamChannel.withCloseGuarantee(io.stdin, io.stdout)
        .transform(StreamChannelTransformer.fromCodec(utf8))
        .transformStream(const LineSplitter())
        .transformSink(
          StreamSinkTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add('$data\n');
            },
          ),
        ),
  );
}
```

This example creates a server that communicates with clients using standard input and output.

## Extending Server Capabilities

MCP servers can be extended with various mixins to add functionality.

### Adding Tool Support

To add tool support, use the `ToolsSupport` mixin:

```dart
class MyMCPServer extends MCPServer with ToolsSupport {
  MyMCPServer(super.channel)
    : super.fromStreamChannel(
        implementation: ServerImplementation(
          name: 'My MCP Server',
          version: '0.1.0',
        ),
        instructions: 'This is an example of an MCP server that supports tools.',
      );

  @override
  FutureOr<InitializeResult> initialize(InitializeRequest request) {
    // Register tools
    registerTool(
      Tool(
        name: 'hello',
        description: 'A tool that returns a greeting',
        inputSchema: ObjectSchema(
          properties: {
            'name': Schema.string(description: 'The name to greet'),
          },
        ),
      ),
      _handleHelloTool,
    );
    
    return super.initialize(request);
  }

  // Tool handler
  Future<CallToolResult> _handleHelloTool(CallToolRequest request) async {
    final name = request.arguments?['name'] as String? ?? 'World';
    return CallToolResult(
      content: [TextContent(text: 'Hello, $name!')],
    );
  }
}
```

### Adding Resource Support

To add resource support, use the `ResourcesSupport` mixin:

```dart
class MyMCPServer extends MCPServer with ResourcesSupport {
  // Resource support implementation
}
```

### Adding Logging Support

To add logging support, use the `LoggingSupport` mixin:

```dart
class MyMCPServer extends MCPServer with LoggingSupport {
  // Logging support implementation
}
```

## Communication with Clients

### Handling Requests from Clients

To handle requests from clients, use the `registerRequestHandler` method:

```dart
@override
FutureOr<InitializeResult> initialize(InitializeRequest request) {
  registerRequestHandler('custom/method', _handleCustomMethod);
  return super.initialize(request);
}

Future<CustomResult> _handleCustomMethod(CustomRequest request) async {
  // Handle custom request
  return CustomResult();
}
```

### Sending Notifications to Clients

To send notifications to clients, use the `sendNotification` method:

```dart
void sendCustomNotification() {
  sendNotification(
    'custom/notification',
    CustomNotification(),
  );
}
```

## Advanced Implementation Examples

### File System Server Example

Here's an example of an MCP server that supports file system operations:

```dart
class FileSystemServer extends MCPServer
    with LoggingSupport, RootsTrackingSupport, ToolsSupport {
  FileSystemServer(super.channel)
    : super.fromStreamChannel(
        implementation: ServerImplementation(
          name: 'File System Server',
          version: '0.1.0',
        ),
      );

  @override
  FutureOr<InitializeResult> initialize(InitializeRequest request) {
    // Register file operation tools
    registerTool(readFileTool, _readFile);
    registerTool(writeFileTool, _writeFile);
    registerTool(deleteFileTool, _deleteFile);
    registerTool(listFilesTool, _listFiles);
    
    return super.initialize(request);
  }

  // Tool implementations (omitted for brevity)
}
```

## Troubleshooting

### Common Issues and Solutions

1. **Connection Issues**: Ensure that the communication channel between the client and server is properly set up.

2. **Initialization Issues**: Make sure that the `initialize` method is properly implemented and all necessary capabilities are registered.

3. **Tool Invocation Errors**: Ensure that the tool input schemas are correctly defined and that handlers properly handle exceptions.

### Debugging Tips

- Use the `protocolLogSink` parameter to log protocol messages:

```dart
MyMCPServer.fromStreamChannel(
  channel,
  implementation: ServerImplementation(
    name: 'My MCP Server',
    version: '0.1.0',
  ),
  protocolLogSink: io.stdout,
);
```

- Use `try-catch` blocks to catch exceptions in handlers and return appropriate error responses.

---

We hope this guide helps you implement custom Machine Communication Protocol (MCP) servers in Dart. For more details, refer to the [dart_mcp package documentation](https://pub.dev/packages/dart_mcp).
