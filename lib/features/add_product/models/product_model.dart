
import 'package:flutter/foundation.dart';
import 'package:myapp/features/add_product/models/product_variant_model.dart';
import 'package:myapp/features/add_product/models/variant_model.dart';

@immutable
class Product {
  final String id;
  final String name;
  final String? description;
  final double price;
  final double? salePrice;
  final int? stock;
  final List<String> images;
  final List<String> categories;
  final bool isDraft;
  final DateTime? savedAt;
  final List<VariantOption> variants;
  final List<ProductVariant> productVariants;

  const Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.salePrice,
    this.stock,
    this.images = const [],
    this.categories = const [],
    this.isDraft = false,
    this.savedAt,
    this.variants = const [],
    this.productVariants = const [],
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? salePrice,
    int? stock,
    List<String>? images,
    List<String>? categories,
    bool? isDraft,
    DateTime? savedAt,
    List<VariantOption>? variants,
    List<ProductVariant>? productVariants,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      stock: stock ?? this.stock,
      images: images ?? this.images,
      categories: categories ?? this.categories,
      isDraft: isDraft ?? this.isDraft,
      savedAt: savedAt ?? this.savedAt,
      variants: variants ?? this.variants,
      productVariants: productVariants ?? this.productVariants,
    );
  }
}
