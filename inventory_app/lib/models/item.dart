import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  const Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final int quantity;
  final double price;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get inStock => quantity > 0;

  Item copyWith({
    String? id,
    String? name,
    int? quantity,
    double? price,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory Item.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? _,
  ) {
    final data = snapshot.data();

    if (data == null) {
      throw StateError('Missing Firestore data for item ${snapshot.id}.');
    }

    final quantityRaw = data['quantity'];
    final priceRaw = data['price'];
    final createdAtRaw = data['createdAt'];
    final updatedAtRaw = data['updatedAt'];

    return Item(
      id: snapshot.id,
      name: (data['name'] as String?)?.trim() ?? '',
      quantity: quantityRaw is int ? quantityRaw : (quantityRaw as num?)?.toInt() ?? 0,
      price: priceRaw is double ? priceRaw : (priceRaw as num?)?.toDouble() ?? 0,
      createdAt: _toDateTime(createdAtRaw),
      updatedAt: _toDateTime(updatedAtRaw),
    );
  }

  static DateTime _toDateTime(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}
