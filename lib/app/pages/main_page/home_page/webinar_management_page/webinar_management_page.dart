import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:esoi/app/providers/webinar_provider.dart';
import 'package:esoi/app/services/user_service/panel_webinar_service.dart';
import 'package:esoi/common/components.dart';
import 'package:esoi/config/styles.dart';
import 'package:esoi/locator.dart';

class WebinarManagementPage extends StatefulWidget {
  static const String pageName = '/webinar_management';
  final int? courseId;
  
  const WebinarManagementPage({super.key, this.courseId});

  @override
  State<WebinarManagementPage> createState() => _WebinarManagementPageState();
}

class _WebinarManagementPageState extends State<WebinarManagementPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.courseId != null) {
      _fetchWebinarData();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchWebinarData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final chapters = await PanelWebinarService.getWebinarChapters(widget.courseId!);
      if (mounted) {
        locator<WebinarProvider>().setPanelWebinarChapters(chapters);
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return directionality(
      child: Scaffold(
        appBar: appbar(title: 'Webinar Management'),
        body: isLoading
            ? loading()
            : widget.courseId == null
                ? Center(child: Text('Invalid Course ID', style: style14Regular()))
                : Consumer<WebinarProvider>(
                    builder: (context, provider, child) {
                      if (provider.panelWebinarChapters.isEmpty) {
                        return Center(child: Text('No chapters found', style: style14Regular()));
                      }

                      return ListView.builder(
                        padding: padding(horizontal: 20, vertical: 20),
                        physics: const BouncingScrollPhysics(),
                        itemCount: provider.panelWebinarChapters.length,
                        itemBuilder: (context, index) {
                          final chapter = provider.panelWebinarChapters[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(chapter.title ?? 'Chapter', style: style14Bold()),
                              subtitle: Text(chapter.type ?? 'Active', style: style12Regular()),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                // View chapter details
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
      ),
    );
  }
}
