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
          fromFirestore: (snapshot, _) {
            return Item.fromMap(snapshot.data() ?? {}, id: snapshot.id);
          },
          toFirestore: (item, _) {
            return item.toMap();
          },
        );
  }

  Future<void> createItem(Item item) async {
    final now = DateTime.now();
    final itemToCreate = item.copyWith(createdAt: now, updatedAt: now);
    await _itemsRef.add(itemToCreate);
  }

  Future<void> updateItem(Item item) async {
    final itemId = item.id;
    if (itemId == null || itemId.isEmpty) {
      throw ArgumentError('Item id is required to update an item.');
    }

    await _itemsRef
        .doc(itemId)
        .set(item.copyWith(updatedAt: DateTime.now()), SetOptions(merge: true));
  }

  Future<void> deleteItem(String id) {
    return _itemsRef.doc(id).delete();
  }

  Stream<List<Item>> watchItems() {
    return _itemsRef
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<Item?> watchItemById(String id) {
    return _itemsRef.doc(id).snapshots().map((doc) => doc.data());
  }

  Future<Item?> getItemById(String id) async {
    final snapshot = await _itemsRef.doc(id).get();
    return snapshot.data();
  }
}
