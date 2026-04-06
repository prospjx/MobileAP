import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  const Item({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String name;
  final int quantity;
  final double price;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Item.fromMap(Map<String, dynamic> map, {String? id}) {
    return Item(
      id: id,
      name: (map['name'] as String?)?.trim() ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      price: (map['price'] as num?)?.toDouble() ?? 0,
      isAvailable: map['isAvailable'] as bool? ?? true,
      createdAt: _toDateTime(map['createdAt']),
      updatedAt: _toDateTime(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap({bool includeServerTimestamps = false}) {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'isAvailable': isAvailable,
      'createdAt': includeServerTimestamps
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt),
      'updatedAt': includeServerTimestamps
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(updatedAt),
    };
  }

  Item copyWith({
    String? id,
    String? name,
    int? quantity,
    double? price,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime _toDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.now();
  }
}
