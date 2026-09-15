import 'package:flutter/material.dart';
import 'package:esoi/common/components.dart';
import 'package:esoi/config/styles.dart';

class ProductDetailsPage extends StatelessWidget {
  static const String pageName = '/product_details';
  
  final Map<String, dynamic> product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return directionality(
      child: Scaffold(
        appBar: appbar(title: product['title'] ?? 'Product Details'),
        body: SingleChildScrollView(
          padding: padding(horizontal: 20, vertical: 20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product['title'] ?? 'Title',
                style: style20Bold(),
              ),
              space(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product['type'] ?? 'Type',
                    style: style14Regular().copyWith(color: Colors.grey),
                  ),
                  Text(
                    product['price'] != null ? '\$${product['price']}' : 'Free',
                    style: style16Bold(),
                  ),
                ],
              ),
              space(20),
              Text(
                'Description',
                style: style16Bold(),
              ),
              space(10),
              Text(
                product['description'] ?? 'No description available.',
                style: style14Regular(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
