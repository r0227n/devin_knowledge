# Dart MCPサーバーの実装ガイド

## 目次

1. [MCPとは](#mcpとは)
2. [前提条件](#前提条件)
3. [基本的なMCPサーバーの実装](#基本的なmcpサーバーの実装)
4. [サーバー機能の拡張](#サーバー機能の拡張)
5. [クライアントとの通信](#クライアントとの通信)
6. [高度な実装例](#高度な実装例)
7. [トラブルシューティング](#トラブルシューティング)

## MCPとは

MCP（Machine Communication Protocol）は、AIモデルとツールの間の通信を標準化するためのプロトコルです。MCPを使用することで、AIモデルは様々なツールやリソースにアクセスし、より複雑なタスクを実行できるようになります。

Dartでは、`dart_mcp`パッケージを使用してMCPサーバーとクライアントを実装できます。このガイドでは、Dartを使用してカスタムMCPサーバーを作成する方法について説明します。

## 前提条件

MCPサーバーを実装するには、以下が必要です：

- Dart SDK（2.19.0以上）
- `dart_mcp`パッケージ

`pubspec.yaml`ファイルに以下の依存関係を追加します：

```yaml
dependencies:
  dart_mcp: ^0.1.0  # 最新バージョンを確認してください
  stream_channel: ^2.1.0
  async: ^2.10.0
```

## 基本的なMCPサーバーの実装

### 1. 基本的なサーバークラスの作成

MCPサーバーを実装するには、`MCPServer`クラスを拡張します：

```dart
import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:async/async.dart';
import 'package:dart_mcp/server.dart';
import 'package:stream_channel/stream_channel.dart';

/// 基本的なMCPサーバーの実装
class MyMCPServer extends MCPServer {
  MyMCPServer(super.channel)
    : super.fromStreamChannel(
        implementation: ServerImplementation(
          name: 'My MCP Server',
          version: '0.1.0',
        ),
        instructions: 'これは基本的なMCPサーバーの例です。',
      );

  @override
  FutureOr<InitializeResult> initialize(InitializeRequest request) {
    // サーバーの初期化ロジックをここに記述
    return super.initialize(request);
  }
}
```

### 2. サーバーの起動

サーバーを起動するためのメイン関数を作成します：

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

この例では、標準入出力を使用してクライアントと通信するサーバーを作成しています。

## サーバー機能の拡張

MCPサーバーは、様々なミックスインを使用して機能を拡張できます。

### ツールサポートの追加

ツールサポートを追加するには、`ToolsSupport`ミックスインを使用します：

```dart
class MyMCPServer extends MCPServer with ToolsSupport {
  MyMCPServer(super.channel)
    : super.fromStreamChannel(
        implementation: ServerImplementation(
          name: 'My MCP Server',
          version: '0.1.0',
        ),
        instructions: 'これはツールをサポートするMCPサーバーの例です。',
      );

  @override
  FutureOr<InitializeResult> initialize(InitializeRequest request) {
    // ツールの登録
    registerTool(
      Tool(
        name: 'hello',
        description: '挨拶を返すツール',
        inputSchema: ObjectSchema(
          properties: {
            'name': Schema.string(description: '挨拶する相手の名前'),
          },
        ),
      ),
      _handleHelloTool,
    );
    
    return super.initialize(request);
  }

  // ツールのハンドラー
  Future<CallToolResult> _handleHelloTool(CallToolRequest request) async {
    final name = request.arguments?['name'] as String? ?? 'World';
    return CallToolResult(
      content: [TextContent(text: 'Hello, $name!')],
    );
  }
}
```

### リソースサポートの追加

リソースサポートを追加するには、`ResourcesSupport`ミックスインを使用します：

```dart
class MyMCPServer extends MCPServer with ResourcesSupport {
  // リソースサポートの実装
}
```

### ロギングサポートの追加

ロギングサポートを追加するには、`LoggingSupport`ミックスインを使用します：

```dart
class MyMCPServer extends MCPServer with LoggingSupport {
  // ロギングサポートの実装
}
```

## クライアントとの通信

### クライアントからのリクエスト処理

クライアントからのリクエストを処理するには、`registerRequestHandler`メソッドを使用します：

```dart
@override
FutureOr<InitializeResult> initialize(InitializeRequest request) {
  registerRequestHandler('custom/method', _handleCustomMethod);
  return super.initialize(request);
}

Future<CustomResult> _handleCustomMethod(CustomRequest request) async {
  // カスタムリクエストの処理
  return CustomResult();
}
```

### クライアントへの通知送信

クライアントに通知を送信するには、`sendNotification`メソッドを使用します：

```dart
void sendCustomNotification() {
  sendNotification(
    'custom/notification',
    CustomNotification(),
  );
}
```

## 高度な実装例

### ファイルシステムサーバーの例

以下は、ファイルシステム操作をサポートするMCPサーバーの例です：

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
    // ファイル操作ツールの登録
    registerTool(readFileTool, _readFile);
    registerTool(writeFileTool, _writeFile);
    registerTool(deleteFileTool, _deleteFile);
    registerTool(listFilesTool, _listFiles);
    
    return super.initialize(request);
  }

  // ツール実装（省略）
}
```

## トラブルシューティング

### 一般的な問題と解決策

1. **接続の問題**：クライアントとサーバー間の通信チャネルが正しく設定されていることを確認してください。

2. **初期化の問題**：`initialize`メソッドが正しく実装され、必要なすべての機能が登録されていることを確認してください。

3. **ツールの呼び出しエラー**：ツールの入力スキーマが正しく定義され、ハンドラーが例外を適切に処理していることを確認してください。

### デバッグのヒント

- `protocolLogSink`パラメータを使用して、プロトコルメッセージをログに記録します：

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

- `try-catch`ブロックを使用して、ハンドラー内の例外を捕捉し、適切なエラーレスポンスを返します。

---

このガイドが、Dartでカスタムのマシンコミュニケーションプロトコル（MCP）サーバーを実装する際の参考になれば幸いです。詳細については、[dart_mcp パッケージのドキュメント](https://pub.dev/packages/dart_mcp)を参照してください。
