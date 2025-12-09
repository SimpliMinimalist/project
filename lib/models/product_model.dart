
import 'package:flutter/foundation.dart';

@immutable
class Product {
  final String id;
  final String name;
  final double price;
  final int? stock;
  final List<String> images;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.stock,
    required this.images,
  });
}
