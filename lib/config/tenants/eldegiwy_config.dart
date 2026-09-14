import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../api_config.dart';
import '../branding_config.dart';
import '../app_config.dart';

class EldegiwyConfig extends AppConfig {
  @override
  ApiConfig get api => ApiConfig(
        baseUrl: dotenv.env['BASE_URL'] ?? 'https://eldegiwy.elda7e7a.com/api/development/',
        apiKey: dotenv.env['API_KEY'] ?? '123456789',
      );

  @override
  BrandingConfig get branding => const BrandingConfig(
        appName: 'Eldegiwy LMS',
        companyName: 'Eldegiwy',
        logoPath: 'assets/icon/icon.png', // Fallback to existing asset for now
        splashImagePath: 'assets/icon/icon.png',
        primaryColor: Color(0xFF0B6EF0), // Extracted from pubspec.yaml flutter_native_splash config
        secondaryColor: Color(0xFF000000),
        accentColor: Color(0xFF0B6EF0),
      );

  @override
  bool get enableDeveloperCrashScreen => true; // Set to true for internal testing
}
