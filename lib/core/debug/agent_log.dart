import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

// #region agent log
/// Debug-session logger (NDJSON file + HTTP ingest fallback).
Future<void> agentLog({
  required String location,
  required String message,
  required String hypothesisId,
  Map<String, dynamic>? data,
  String runId = 'pre-fix',
}) async {
  final payload = <String, dynamic>{
    'sessionId': '5294c9',
    'timestamp': DateTime.now().millisecondsSinceEpoch,
    'location': location,
    'message': message,
    'hypothesisId': hypothesisId,
    'data': data ?? <String, dynamic>{},
    'runId': runId,
  };
  debugPrint('[agentLog] ${jsonEncode(payload)}');
  try {
    final logFile = File('debug-5294c9.log');
    await logFile.writeAsString('${jsonEncode(payload)}\n', mode: FileMode.append);
  } catch (_) {}
  try {
    final client = HttpClient();
    final request = await client.postUrl(
      Uri.parse(
        'http://127.0.0.1:7303/ingest/d2dfad67-91de-4aab-a993-fb9fb58c8d75',
      ),
    );
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('X-Debug-Session-Id', '5294c9');
    request.write(jsonEncode(payload));
    await request.close();
    client.close();
  } catch (_) {}
}
// #endregion
