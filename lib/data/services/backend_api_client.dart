import 'dart:convert';

import 'package:http/http.dart' as http;

class BackendApiException implements Exception {
  final int statusCode;
  final String message;

  const BackendApiException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() => 'BackendApiException($statusCode): $message';
}

abstract class BackendApiClient {
  Future<Object?> getJson(String path, {String? accessToken});

  Future<Object?> postJson(
    String path, {
    Map<String, Object?>? body,
    String? accessToken,
  });

  Future<Object?> patchJson(
    String path, {
    Map<String, Object?>? body,
    String? accessToken,
  });

  Future<void> delete(String path, {String? accessToken});
}

class HttpBackendApiClient implements BackendApiClient {
  final Uri baseUri;
  final http.Client _client;

  HttpBackendApiClient({
    required String baseUrl,
    http.Client? client,
  })  : baseUri = Uri.parse(baseUrl),
        _client = client ?? http.Client();

  @override
  Future<Object?> getJson(String path, {String? accessToken}) {
    return _sendJson('GET', path, accessToken: accessToken);
  }

  @override
  Future<Object?> postJson(
    String path, {
    Map<String, Object?>? body,
    String? accessToken,
  }) {
    return _sendJson('POST', path, body: body, accessToken: accessToken);
  }

  @override
  Future<Object?> patchJson(
    String path, {
    Map<String, Object?>? body,
    String? accessToken,
  }) {
    return _sendJson('PATCH', path, body: body, accessToken: accessToken);
  }

  @override
  Future<void> delete(String path, {String? accessToken}) async {
    await _sendJson('DELETE', path, accessToken: accessToken);
  }

  Future<Object?> _sendJson(
    String method,
    String path, {
    Map<String, Object?>? body,
    String? accessToken,
  }) async {
    final request = http.Request(method, _resolve(path));
    request.headers['accept'] = 'application/json';
    request.headers['content-type'] = 'application/json';
    if (accessToken != null) {
      request.headers['authorization'] = 'Bearer $accessToken';
    }
    if (body != null) {
      request.body = jsonEncode(body);
    }

    final streamed = await _client.send(request);
    final response = await http.Response.fromStream(streamed);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw BackendApiException(
        statusCode: response.statusCode,
        message: _errorMessage(response),
      );
    }
    if (response.body.trim().isEmpty) {
      return null;
    }
    return jsonDecode(response.body) as Object?;
  }

  Uri _resolve(String path) {
    final normalizedBase = baseUri.path.endsWith('/')
        ? baseUri
        : baseUri.replace(path: '${baseUri.path}/');
    return normalizedBase
        .resolve(path.startsWith('/') ? path.substring(1) : path);
  }

  String _errorMessage(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded case {'message': final Object message}) {
        return message.toString();
      }
    } catch (_) {
      // Fall through to raw body.
    }
    return response.body.trim().isEmpty
        ? '请求失败（${response.statusCode}）'
        : response.body.trim();
  }
}
