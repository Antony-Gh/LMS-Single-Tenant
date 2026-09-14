import 'dart:async';
import 'dart:collection';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../../config/app_config.dart';
import '../../locator.dart';
import '../../app/providers/user_provider.dart';
import '../../common/data/app_language.dart';

class CrashRouteObserver extends NavigatorObserver {
  final Queue<String> _routeHistory = Queue<String>();
  final int maxHistory = 10;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _addRoute(route.settings.name ?? 'unknown_route');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      _addRoute(newRoute.settings.name ?? 'unknown_route');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      _addRoute(previousRoute.settings.name ?? 'unknown_route');
    }
  }

  void _addRoute(String name) {
    if (_routeHistory.length >= maxHistory) {
      _routeHistory.removeFirst();
    }
    _routeHistory.addLast(name);
  }

  String getHistoryString() {
    return _routeHistory.isEmpty ? 'No routing history' : _routeHistory.join(' -> ');
  }
}

class CrashHandler {
  // Singleton pattern
  CrashHandler._internal();
  static final CrashHandler _instance = CrashHandler._internal();
  static CrashHandler get instance => _instance;

  final CrashRouteObserver routeObserver = CrashRouteObserver();

  String? _appVersion;
  String? _buildNumber;
  String? _deviceModel;
  String? _osVersion;
  String? _lastCrashId;

  Future<void> initialize() async {
    // 1. Collect Device and App Info
    await _collectDeviceInfo();

    // 2. Setup Firebase Crashlytics if available and not on web
    if (!kIsWeb) {
      // Pass all uncaught "fatal" errors from the framework to Crashlytics
      FlutterError.onError = (errorDetails) {
        _prepareCrashState();
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };

      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        _prepareCrashState();
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      // Set custom keys for breadcrumbs that don't change
      FirebaseCrashlytics.instance.setCustomKey('app_version', _appVersion ?? 'unknown');
      FirebaseCrashlytics.instance.setCustomKey('device_model', _deviceModel ?? 'unknown');
    }
  }

  void _prepareCrashState() {
    // Generate a deterministic Crash ID (e.g. CR-20260727-8D4A21F7)
    final dateStr = DateFormat('yyyyMMdd').format(DateTime.now());
    final uuidPart = const Uuid().v4().substring(0, 8).toUpperCase();
    _lastCrashId = 'CR-$dateStr-$uuidPart';

    if (!kIsWeb) {
      FirebaseCrashlytics.instance.setCustomKey('crash_id', _lastCrashId!);
      FirebaseCrashlytics.instance.setCustomKey('build_mode', kReleaseMode ? 'Release' : (kProfileMode ? 'Profile' : 'Debug'));
      FirebaseCrashlytics.instance.setCustomKey('route_history', routeObserver.getHistoryString());

      // Attempt to capture dynamic application state
      try {
        if (locator.isRegistered<AppConfig>()) {
          FirebaseCrashlytics.instance.setCustomKey('tenant', locator<AppConfig>().branding.appName);
        }
        if (locator.isRegistered<UserProvider>()) {
          final userId = locator<UserProvider>().profile?.id?.toString() ?? 'guest';
          FirebaseCrashlytics.instance.setCustomKey('user_id', userId);
        }
        if (locator.isRegistered<AppLanguage>()) {
          FirebaseCrashlytics.instance.setCustomKey('language', locator<AppLanguage>().currentLanguage);
        }
      } catch (e) {
        debugPrint('CrashHandler: Failed to collect dynamic state: $e');
      }
    }
  }

  Future<void> _collectDeviceInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _appVersion = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;

      final deviceInfo = DeviceInfoPlugin();
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await deviceInfo.androidInfo;
        _deviceModel = androidInfo.model;
        _osVersion = androidInfo.version.release;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfo.iosInfo;
        _deviceModel = iosInfo.utsname.machine;
        _osVersion = iosInfo.systemVersion;
      }
    } catch (e) {
      debugPrint("Failed to collect device info: $e");
    }
  }

  /// Manually log an exception (e.g. from Dio Interceptors)
  void recordError(dynamic exception, StackTrace? stack, {String? reason}) {
    _prepareCrashState();
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.recordError(
        exception, 
        stack, 
        reason: reason, 
        fatal: false, // Not a fatal crash if caught manually
      );
    }
    debugPrint('CrashHandler Log: $reason -> $exception');
  }

  /// Add custom breadcrumb
  void logBreadcrumb(String message) {
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.log(message);
    }
    debugPrint('Breadcrumb: $message');
  }

  // Getters for Crash Screen UI
  String get appVersion => _appVersion ?? 'Unknown';
  String get buildNumber => _buildNumber ?? 'Unknown';
  String get deviceModel => _deviceModel ?? 'Unknown';
  String get osVersion => _osVersion ?? 'Unknown';
  String get lastCrashId => _lastCrashId ?? 'UNKNOWN';
}
