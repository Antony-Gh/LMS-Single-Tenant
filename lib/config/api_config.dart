import 'package:flutter/material.dart';

class ApiConfig {
  final String baseUrl;
  // If a specific tenant requires a hardcoded API key (though ideally removed later)
  final String? apiKey;

  const ApiConfig({
    required this.baseUrl,
    this.apiKey,
  });
}
