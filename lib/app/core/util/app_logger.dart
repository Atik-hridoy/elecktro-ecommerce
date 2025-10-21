// ============================================================================
// File: lib/core/utils/app_logger.dart
// ============================================================================

import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
  api,
  success,
}

class AppLogger {
  static const String _appName = 'ElectronicApp';
  static const bool _enableLogs = kDebugMode; // Only log in debug mode

  // ANSI Color Codes for Console
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _magenta = '\x1B[35m';
  static const String _cyan = '\x1B[36m';
  static const String _white = '\x1B[37m';
  static const String _bold = '\x1B[1m';

  // ========== GENERAL LOGGING ==========

  /// Debug log (Blue)
  static void debug(String message, {String? tag}) {
    _log(LogLevel.debug, message, tag: tag);
  }

  /// Info log (Cyan)
  static void info(String message, {String? tag}) {
    _log(LogLevel.info, message, tag: tag);
  }

  /// Warning log (Yellow)
  static void warning(String message, {String? tag}) {
    _log(LogLevel.warning, message, tag: tag);
  }

  /// Error log (Red)
  static void error(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Success log (Green)
  static void success(String message, {String? tag}) {
    _log(LogLevel.success, message, tag: tag);
  }

  // ========== API LOGGING ==========

  /// Log API Request
  static void apiRequest({
    required String method,
    required String endpoint,
    Map<String, dynamic>? headers,
    dynamic body,
    Map<String, dynamic>? queryParams,
  }) {
    if (!_enableLogs) return;

    final buffer = StringBuffer();
    buffer.writeln('$_cyan$_bold╔════════════════════════════════════════════════════════════════════════════════════════════════════════════════$_reset');
    buffer.writeln('$_cyan$_bold║ 📤 API REQUEST$_reset');
    buffer.writeln('$_cyan$_bold╠════════════════════════════════════════════════════════════════════════════════════════════════════════════════$_reset');
    buffer.writeln('$_cyan║ Method:   $_white$_bold$method$_reset');
    buffer.writeln('$_cyan║ Endpoint: $_white$endpoint$_reset');
    
    if (queryParams != null && queryParams.isNotEmpty) {
      buffer.writeln('$_cyan║ Query Params:$_reset');
      queryParams.forEach((key, value) {
        buffer.writeln('$_cyan║   • $key: $_white$value$_reset');
      });
    }
    
    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('$_cyan║ Headers:$_reset');
      headers.forEach((key, value) {
        buffer.writeln('$_cyan║   • $key: $_white$value$_reset');
      });
    }
    
    if (body != null) {
      buffer.writeln('$_cyan║ Body:$_reset');
      try {
        final prettyBody = _prettyJson(body);
        prettyBody.split('\n').forEach((line) {
          buffer.writeln('$_cyan║   $_white$line$_reset');
        });
      } catch (e) {
        buffer.writeln('$_cyan║   $_white$body$_reset');
      }
    }
    
    buffer.writeln('$_cyan$_bold╚════════════════════════════════════════════════════════════════════════════════════════════════════════════════$_reset');
    
    developer.log(
      buffer.toString(),
      name: '$_appName.API',
      time: DateTime.now(),
    );
  }

  /// Log API Response
  static void apiResponse({
    required String method,
    required String endpoint,
    required int statusCode,
    dynamic responseData,
    Duration? duration,
  }) {
    if (!_enableLogs) return;

    final isSuccess = statusCode >= 200 && statusCode < 300;
    final color = isSuccess ? _green : _red;
    final icon = isSuccess ? '✅' : '❌';
    
    final buffer = StringBuffer();
    buffer.writeln('$color$_bold╔═════════════════════════════════════════════════════════════════════════════════════════════════════════════$_reset');
    buffer.writeln('$color$_bold║ $icon API RESPONSE$_reset');
    buffer.writeln('$color$_bold╠═════════════════════════════════════════════════════════════════════════════════════════════════════════════$_reset');
    buffer.writeln('$color║ Method:      $_white$_bold$method$_reset');
    buffer.writeln('$color║ Endpoint:    $_white$endpoint$_reset');
    buffer.writeln('$color║ Status Code: $_white$_bold$statusCode ${_getStatusText(statusCode)}$_reset');
    
    if (duration != null) {
      buffer.writeln('$color║ Duration:    $_white${duration.inMilliseconds}ms$_reset');
    }
    
    if (responseData != null) {
      buffer.writeln('$color║ Response:$_reset');
      try {
        final prettyResponse = _prettyJson(responseData);
        prettyResponse.split('\n').forEach((line) {
          buffer.writeln('$color║   $_white$line$_reset');
        });
      } catch (e) {
        buffer.writeln('$color║   $_white$responseData$_reset');
      }
    }
    
    buffer.writeln('$color$_bold╚═════════════════════════════════════════════════════════════════════════════════════════════════════════════$_reset');
    
    developer.log(
      buffer.toString(),
      name: '$_appName.API',
      time: DateTime.now(),
    );
  }

  /// Log API Error
  static void apiError({
    required String method,
    required String endpoint,
    required dynamic error,
    int? statusCode,
    StackTrace? stackTrace,
  }) {
    if (!_enableLogs) return;

    final buffer = StringBuffer();
    buffer.writeln('$_red$_bold╔═════════════════════════════════════════════════════════════════════════════════════════════════════════════$_reset');
    buffer.writeln('$_red$_bold║ ⚠️  API ERROR$_reset');
    buffer.writeln('$_red$_bold╠═════════════════════════════════════════════════════════════════════════════════════════════════════════════$_reset');
    buffer.writeln('$_red║ Method:      $_white$_bold$method$_reset');
    buffer.writeln('$_red║ Endpoint:    $_white$endpoint$_reset');
    
    if (statusCode != null) {
      buffer.writeln('$_red║ Status Code: $_white$_bold$statusCode ${_getStatusText(statusCode)}$_reset');
    }
    
    buffer.writeln('$_red║ Error:       $_white$error$_reset');
    
    if (stackTrace != null) {
      buffer.writeln('$_red║ Stack Trace:$_reset');
      stackTrace.toString().split('\n').take(5).forEach((line) {
        buffer.writeln('$_red║   $_white$line$_reset');
      });
    }
    
    buffer.writeln('$_red$_bold╚═════════════════════════════════════════════════════════════════════════════════════════════════════════════$_reset');
    
    developer.log(
      buffer.toString(),
      name: '$_appName.API',
      time: DateTime.now(),
      level: 1000, // Error level
      error: error,
      stackTrace: stackTrace,
    );
  }

  // ========== PRIVATE HELPERS ==========

  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (!_enableLogs) return;

    final logTag = tag ?? _appName;
    final emoji = _getEmoji(level);
    final color = _getColor(level);
    final levelText = level.name.toUpperCase();
    
    final formattedMessage = '$color$_bold[$levelText] $emoji $_reset$color$message$_reset';
    
    developer.log(
      formattedMessage,
      name: logTag,
      time: DateTime.now(),
      level: _getLogLevel(level),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static String _getEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🐛';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
      case LogLevel.api:
        return '🌐';
      case LogLevel.success:
        return '✅';
    }
  }

  static String _getColor(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return _blue;
      case LogLevel.info:
        return _cyan;
      case LogLevel.warning:
        return _yellow;
      case LogLevel.error:
        return _red;
      case LogLevel.api:
        return _magenta;
      case LogLevel.success:
        return _green;
    }
  }

  static int _getLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.api:
        return 800;
      case LogLevel.success:
        return 800;
    }
  }

  static String _getStatusText(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) return '✓ Success';
    if (statusCode >= 300 && statusCode < 400) return '↻ Redirect';
    if (statusCode >= 400 && statusCode < 500) return '⚠ Client Error';
    if (statusCode >= 500) return '❌ Server Error';
    return '';
  }

  static String _prettyJson(dynamic json) {
    try {
      final jsonString = json is String ? json : jsonEncode(json);
      final object = jsonDecode(jsonString);
      return const JsonEncoder.withIndent('  ').convert(object);
    } catch (e) {
      return json.toString();
    }
  }

  // ========== NAVIGATION LOGGING ==========

  /// Log screen navigation
  static void navigation(String from, String to) {
    if (!_enableLogs) return;
    info('Navigation: $from → $to', tag: 'Navigation');
  }

  // ========== STATE LOGGING ==========

  /// Log state changes
  static void state(String stateName, dynamic value) {
    if (!_enableLogs) return;
    debug('State Changed: $stateName = $value', tag: 'State');
  }

  // ========== LIFECYCLE LOGGING ==========

  /// Log widget lifecycle
  static void lifecycle(String widgetName, String event) {
    if (!_enableLogs) return;
    debug('$widgetName: $event', tag: 'Lifecycle');
  }
}

// ============================================================================
// USAGE EXAMPLES
// ============================================================================

/*

// 1. GENERAL LOGGING
AppLogger.debug('This is a debug message');
AppLogger.info('User logged in successfully', tag: 'Auth');
AppLogger.warning('Low storage space');
AppLogger.error('Failed to load data', error: e, stackTrace: stackTrace);
AppLogger.success('Profile updated!');

// 2. API LOGGING

// Request
AppLogger.apiRequest(
  method: 'POST',
  endpoint: '/api/v1/login',
  headers: {'Content-Type': 'application/json'},
  body: {'email': 'user@example.com', 'password': '****'},
);

// Response (Success)
AppLogger.apiResponse(
  method: 'POST',
  endpoint: '/api/v1/login',
  statusCode: 200,
  responseData: {'token': 'abc123', 'user': {...}},
  duration: Duration(milliseconds: 450),
);

// Response (Error)
AppLogger.apiError(
  method: 'POST',
  endpoint: '/api/v1/login',
  error: 'Invalid credentials',
  statusCode: 401,
);

// 3. NAVIGATION LOGGING
AppLogger.navigation('AuthView', 'HomeView');

// 4. STATE LOGGING
AppLogger.state('isLoading', true);
AppLogger.state('userList', users);

// 5. LIFECYCLE LOGGING
AppLogger.lifecycle('HomeView', 'initState');
AppLogger.lifecycle('HomeView', 'dispose');

*/