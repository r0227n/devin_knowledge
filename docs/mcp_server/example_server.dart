// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:async/async.dart';
import 'package:dart_mcp/server.dart';
import 'package:stream_channel/stream_channel.dart';

/// Example of a custom MCP server implementation
void main() {
  CustomMCPServer(
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

/// A custom MCP server with tool support
class CustomMCPServer extends MCPServer with ToolsSupport, LoggingSupport {
  CustomMCPServer(super.channel)
    : super.fromStreamChannel(
        implementation: ServerImplementation(
          name: 'Custom MCP Server',
          version: '0.1.0',
        ),
        instructions: 'A custom MCP server with various tools.',
      );

  @override
  FutureOr<InitializeResult> initialize(InitializeRequest request) {
    // Register calculator tools
    registerTool(
      Tool(
        name: 'add',
        description: 'Adds two numbers',
        inputSchema: ObjectSchema(
          properties: {
            'a': Schema.num(description: 'First number'),
            'b': Schema.num(description: 'Second number'),
          },
          required: ['a', 'b'],
        ),
      ),
      _handleAddTool,
    );

    registerTool(
      Tool(
        name: 'multiply',
        description: 'Multiplies two numbers',
        inputSchema: ObjectSchema(
          properties: {
            'a': Schema.num(description: 'First number'),
            'b': Schema.num(description: 'Second number'),
          },
          required: ['a', 'b'],
        ),
      ),
      _handleMultiplyTool,
    );

    registerTool(
      Tool(
        name: 'echo',
        description: 'Echoes back the input text',
        inputSchema: ObjectSchema(
          properties: {
            'text': Schema.string(description: 'Text to echo'),
          },
          required: ['text'],
        ),
      ),
      _handleEchoTool,
    );

    return super.initialize(request);
  }

  // Tool handlers
  Future<CallToolResult> _handleAddTool(CallToolRequest request) async {
    try {
      final a = request.arguments!['a'] as num;
      final b = request.arguments!['b'] as num;
      final result = a + b;
      
      return CallToolResult(
        content: [TextContent(text: 'Result: $result')],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Error: ${e.toString()}')],
        isError: true,
      );
    }
  }

  Future<CallToolResult> _handleMultiplyTool(CallToolRequest request) async {
    try {
      final a = request.arguments!['a'] as num;
      final b = request.arguments!['b'] as num;
      final result = a * b;
      
      return CallToolResult(
        content: [TextContent(text: 'Result: $result')],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Error: ${e.toString()}')],
        isError: true,
      );
    }
  }

  Future<CallToolResult> _handleEchoTool(CallToolRequest request) async {
    try {
      final text = request.arguments!['text'] as String;
      
      return CallToolResult(
        content: [TextContent(text: text)],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Error: ${e.toString()}')],
        isError: true,
      );
    }
  }
}
