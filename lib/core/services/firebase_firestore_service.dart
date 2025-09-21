import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  FirebaseFirestoreService._();
  static final instance = FirebaseFirestoreService._();

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data, SetOptions(merge: merge));
  }

  Future<DocumentReference> addData({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.collection(collectionPath);
    return await reference.add(data);
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  Future<void> bulkAdd({
    required String collectionPath,
    required List<Map<String, dynamic>> data,
  }) async {
    final batch = FirebaseFirestore.instance.batch();
    final collectionRef = FirebaseFirestore.instance.collection(collectionPath);
    for (final item in data) {
      final docRef = collectionRef.doc(); // auto-generate ID
      batch.set(docRef, item);
    }
    await batch.commit();
  }

  Future<void> bulkUpdate({
    required String collectionPath,
    required Map<String, Map<String, dynamic>> data, // Map of docId to data
  }) async {
    final batch = FirebaseFirestore.instance.batch();
    data.forEach((docId, itemData) {
      final docRef = FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(docId);
      batch.update(docRef, itemData);
    });
    await batch.commit();
  }

  Future<void> bulkDelete({
    required String collectionPath,
    required List<String> docIds,
  }) async {
    final batch = FirebaseFirestore.instance.batch();
    for (final docId in docIds) {
      final docRef = FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(docId);
      batch.delete(docRef);
    }
    await batch.commit();
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) =>
          snapshot.docs.map((doc) => builder(doc.data(), doc.id)).toList(),
    );
  }
}
