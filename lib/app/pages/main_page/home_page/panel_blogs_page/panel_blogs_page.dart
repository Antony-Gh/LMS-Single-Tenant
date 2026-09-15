import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:esoi/app/providers/blog_provider.dart';
import 'package:esoi/app/services/user_service/panel_blog_service.dart';
import 'package:esoi/common/components.dart';
import 'package:esoi/config/styles.dart';
import 'package:esoi/locator.dart';

class PanelBlogsPage extends StatefulWidget {
  static const String pageName = '/panel_blogs';
  const PanelBlogsPage({super.key});

  @override
  State<PanelBlogsPage> createState() => _PanelBlogsPageState();
}

class _PanelBlogsPageState extends State<PanelBlogsPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBlogs();
  }

  Future<void> _fetchBlogs() async {
    setState(() {
      isLoading = true;
    });

    try {
      final blogs = await PanelBlogService.getBlogs();
      if (mounted) {
        locator<BlogProvider>().setPanelBlogs(blogs);
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
        appBar: appbar(title: 'My Blogs'),
        body: isLoading
            ? loading()
            : Consumer<BlogProvider>(
                builder: (context, provider, child) {
                  if (provider.panelBlogs.isEmpty) {
                    return Center(child: Text('You have no blogs', style: style14Regular()));
                  }

                  return ListView.builder(
                    padding: padding(horizontal: 20, vertical: 20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: provider.panelBlogs.length,
                    itemBuilder: (context, index) {
                      final blog = provider.panelBlogs[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(blog['title'] ?? 'Blog Title', style: style14Bold()),
                          subtitle: Text(blog['status'] ?? 'Status', style: style12Regular()),
                          trailing: const Icon(Icons.edit, size: 20),
                          onTap: () {
                            // Navigate to edit blog
                          },
                        ),
                      );
                    },
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to create new blog
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
