import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/item.dart';

class ItemFirestoreService {
  ItemFirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Item> get _itemsRef {
    return _firestore
        .collection('items')
        .withConverter<Item>(
          fromFirestore: Item.fromFirestore,
          toFirestore: (item, _) => item.toFirestore(),
        );
  }

  Stream<List<Item>> watchItems() {
    return _itemsRef
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<Item?> watchItemById(String id) {
    return _itemsRef.doc(id).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return snapshot.data();
    });
  }

  Future<String> createItem({
    required String name,
    required int quantity,
    required double price,
  }) async {
    final now = DateTime.now();
    final newRef = _itemsRef.doc();
    final item = Item(
      id: newRef.id,
      name: name.trim(),
      quantity: quantity,
      price: price,
      createdAt: now,
      updatedAt: now,
    );

    await newRef.set(item);
    return newRef.id;
  }

  Future<void> updateItem(Item item) {
    final updated = item.copyWith(updatedAt: DateTime.now());
    return _itemsRef.doc(item.id).set(updated);
  }

  Future<void> updateStock({required String id, required int quantity}) {
    return _itemsRef.doc(id).update({
      'quantity': quantity,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> deleteItem(String id) {
    return _itemsRef.doc(id).delete();
  }
}
