import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:restart_app/restart_app.dart';
import '../../../../config/app_config.dart';
import '../../../../core/error/crash_handler.dart';
import '../../../../locator.dart';

class CustomCrashScreen extends StatefulWidget {
  final FlutterErrorDetails errorDetails;

  const CustomCrashScreen({super.key, required this.errorDetails});

  @override
  State<CustomCrashScreen> createState() => _CustomCrashScreenState();
}

class _CustomCrashScreenState extends State<CustomCrashScreen> {
  bool _showDetails = false;

  void _restartApp() {
    Restart.restartApp();
  }

  Future<void> _sendReport() async {
    final crashId = CrashHandler.instance.lastCrashId;
    final subject = Uri.encodeComponent('Crash Report: $crashId');
    final body = Uri.encodeComponent(
      "Crash ID: $crashId\n"
      "Device: ${CrashHandler.instance.deviceModel}\n"
      "OS: ${CrashHandler.instance.osVersion}\n"
      "App Version: ${CrashHandler.instance.appVersion} (${CrashHandler.instance.buildNumber})\n\n"
      "Please describe what you were doing when the app crashed:\n\n"
    );

    String supportEmail = 'support@esoi.com';
    try {
      if (locator.isRegistered<AppConfig>()) {
        supportEmail = locator<AppConfig>().branding.supportEmail ?? supportEmail;
      }
    } catch (_) {}

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: 'subject=$subject&body=$body',
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If it's a small constraint (inline layout error), just show an error icon
        // so it doesn't break the entire screen
        if (constraints.maxWidth < 150 || constraints.maxHeight < 150) {
          return Center(
            child: IconButton(
              icon: const Icon(Icons.error_outline, color: Colors.redAccent),
              onPressed: () {
                // Ignore the error if tapped, but it shows it's a broken widget
              },
              tooltip: 'Widget rendering error',
            )
          );
        }

        return _buildFullCrashScreen(context);
      },
    );
  }

  Widget _buildFullCrashScreen(BuildContext context) {
    bool enableDeveloperScreen = false;
    try {
      enableDeveloperScreen = locator<AppConfig>().enableDeveloperCrashScreen;
    } catch (_) {}

    final bool showDevInfo = kDebugMode || enableDeveloperScreen;
    final crashId = CrashHandler.instance.lastCrashId;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  const Icon(Icons.error_outline, size: 80, color: Colors.redAccent),
                  const SizedBox(height: 24),
                  const Text(
                    'Oops! Something went wrong',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'The app encountered an unexpected error.\nWe have been notified and are looking into it.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Crash ID: $crashId',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black45),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Restart Button
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Restart App'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF0B6EF0),
                    ),
                    onPressed: _restartApp,
                  ),
                  const SizedBox(height: 12),
                  
                  // Send Report Button
                  OutlinedButton.icon(
                    icon: const Icon(Icons.email_outlined),
                    label: const Text('Send Report'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: const Color(0xFF0B6EF0),
                    ),
                    onPressed: _sendReport,
                  ),

                  const SizedBox(height: 40),

                  // Developer Section
                  if (showDevInfo) ...[
                    const Divider(),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _showDetails = !_showDetails;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Technical Details', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                            Icon(_showDetails ? Icons.expand_less : Icons.expand_more, color: Colors.blueGrey),
                          ],
                        ),
                      ),
                    ),
                    if (_showDetails) ...[
                      const SizedBox(height: 8),
                      _buildDetailRow('Device', CrashHandler.instance.deviceModel),
                      _buildDetailRow('OS', CrashHandler.instance.osVersion),
                      _buildDetailRow('App Version', '${CrashHandler.instance.appVersion} (${CrashHandler.instance.buildNumber})'),
                      _buildDetailRow('Crash ID', crashId),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.errorDetails.exceptionAsString(),
                          style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace', fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.copy, size: 18),
                        label: const Text('Copy Error'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black87, backgroundColor: Colors.grey.shade300,
                          elevation: 0,
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                            text: "Crash ID: $crashId\n"
                                  "Device: ${CrashHandler.instance.deviceModel}\n"
                                  "OS: ${CrashHandler.instance.osVersion}\n"
                                  "Error: ${widget.errorDetails.exceptionAsString()}\n"
                                  "Stack: ${widget.errorDetails.stack}",
                          ));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error copied to clipboard')),
                          );
                        },
                      ),
                    ]
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12, color: Colors.black54))),
        ],
      ),
    );
  }
}
