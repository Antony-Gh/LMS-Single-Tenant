import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:esoi/app/providers/instructor_provider.dart';
import 'package:esoi/app/services/user_service/instructor_bundle_service.dart';
import 'package:esoi/common/components.dart';
import 'package:esoi/config/styles.dart';
import 'package:esoi/locator.dart';

class InstructorDashboardPage extends StatefulWidget {
  static const String pageName = '/instructor_dashboard';
  const InstructorDashboardPage({super.key});

  @override
  State<InstructorDashboardPage> createState() => _InstructorDashboardPageState();
}

class _InstructorDashboardPageState extends State<InstructorDashboardPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final bundles = await InstructorBundleService.getBundles();
      if (mounted) {
        locator<InstructorProvider>().setBundles(bundles);
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
        appBar: appbar(title: 'Instructor Dashboard'),
        body: isLoading
            ? loading()
            : Consumer<InstructorProvider>(
                builder: (context, provider, child) {
                  return SingleChildScrollView(
                    padding: padding(horizontal: 20, vertical: 20),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My Bundles', style: style20Bold()),
                        space(10),
                        if (provider.bundles.isEmpty)
                          Text('You have no bundles yet.', style: style14Regular())
                        else
                          ...provider.bundles.map((bundle) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                title: Text(bundle.title ?? 'Bundle', style: style14Bold()),
                                subtitle: Text(bundle.status ?? 'Draft', style: style12Regular()),
                                trailing: const Icon(Icons.edit, size: 20),
                                onTap: () {
                                  // Edit bundle
                                },
                              ),
                            );
                          }),
                      ],
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Create new bundle
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
