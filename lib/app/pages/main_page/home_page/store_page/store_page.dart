import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:esoi/app/providers/store_provider.dart';
import 'package:esoi/app/services/user_service/store_service.dart';
import 'package:esoi/common/components.dart';
import 'package:esoi/common/common.dart';
import 'package:esoi/config/styles.dart';
import 'package:esoi/locator.dart';

class StorePage extends StatefulWidget {
  static const String pageName = '/store';
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final products = await StoreService.getProducts();
      if (mounted) {
        locator<StoreProvider>().setProducts(products);
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
        appBar: appbar(title: 'Store'),
        body: isLoading
            ? loading()
            : Consumer<StoreProvider>(
                builder: (context, provider, child) {
                  if (provider.products.isEmpty) {
                    return Center(child: Text('No products available', style: style14Regular()));
                  }

                  return ListView.builder(
                    padding: padding(horizontal: 20, vertical: 20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: provider.products.length,
                    itemBuilder: (context, index) {
                      final product = provider.products[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(product.title ?? 'Product Title', style: style14Bold()),
                          subtitle: Text(product.type ?? 'Product Type', style: style12Regular()),
                          trailing: Text(product.price != null ? '\$${product.price}' : 'Free', style: style14Bold()),
                          onTap: () {
                            // Navigate to product details
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
