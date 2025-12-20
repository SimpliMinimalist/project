
import 'package:flutter/foundation.dart';

@immutable
class Product {
  final String id;
  final String name;
  final String? description;
  final double price;
  final double? salePrice;
  final int? stock;
  final List<String> images;
  final String? category;
  final bool isDraft;
  final DateTime? savedAt;

  const Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.salePrice,
    this.stock,
    this.images = const [],
    this.category,
    this.isDraft = false,
    this.savedAt,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? salePrice,
    int? stock,
    List<String>? images,
    String? category,
    bool? isDraft,
    DateTime? savedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      stock: stock ?? this.stock,
      images: images ?? this.images,
      category: category ?? this.category,
      isDraft: isDraft ?? this.isDraft,
      savedAt: savedAt ?? this.savedAt,
    );
  }
}
