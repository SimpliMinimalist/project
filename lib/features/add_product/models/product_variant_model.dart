import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

@immutable
class ProductVariant {
  final String id;
  final Map<String, String> attributes;
  final double price;
  final int stock;
  final String? image;

  ProductVariant({
    String? id,
    required this.attributes,
    this.price = 0.0,
    this.stock = 0,
    this.image,
  }) : id = id ?? const Uuid().v4();

  String get name {
    if (attributes.isEmpty) {
      return 'Default';
    }
    return attributes.values.join(' / ');
  }

  ProductVariant copyWith({
    String? id,
    Map<String, String>? attributes,
    double? price,
    int? stock,
    String? image,
    bool? isSelected,
  }) {
    return ProductVariant(
      id: id ?? this.id,
      attributes: attributes ?? this.attributes,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      image: image ?? this.image,
    );
  }

  static bool aresSame(ProductVariant a, ProductVariant b) {
    const mapEquality = MapEquality<String, String>();
    return mapEquality.equals(a.attributes, b.attributes);
  }
}
