
import 'package:flutter/foundation.dart';

@immutable
class VariantOption {
  final String name;
  final List<String> values;

  const VariantOption({
    required this.name,
    required this.values,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'values': values,
    };
  }
}
