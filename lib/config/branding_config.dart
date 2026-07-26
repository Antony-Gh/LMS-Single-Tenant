import 'package:flutter/material.dart';

class BrandingConfig {
  final String appName;
  final String companyName;
  final String logoPath;
  final String splashImagePath;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final String? supportEmail;
  final String? privacyPolicyUrl;
  final String? termsUrl;
  final String? websiteUrl;

  const BrandingConfig({
    required this.appName,
    required this.companyName,
    required this.logoPath,
    required this.splashImagePath,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    this.supportEmail,
    this.privacyPolicyUrl,
    this.termsUrl,
    this.websiteUrl,
  });
}
