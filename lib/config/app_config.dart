import 'package:flutter/material.dart';
import 'api_config.dart';
import 'branding_config.dart';

abstract class AppConfig {
  ApiConfig get api;
  BrandingConfig get branding;
}
