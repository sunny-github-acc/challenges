import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:challenges/components/modal.dart';

class CloudService {
  Future<void> setCollection(context, collection, document) async {
    try {
      final finalDocument =
          await FirebaseFirestore.instance.collection(collection).add(document);
      final documentId = finalDocument.id;

      Map<String, dynamic> updatedData = {'id': documentId, ...document};

      await updateCollection(context, collection, updatedData, documentId);

      Navigator.pop(context);
      Modal.show(context, 'Congrats!', 'The $collection is added');
    } catch (error) {
      Modal.show(context, 'Oops', 'Failed to add the $collection : $error');
    }
  }

  Future<void> updateCollection(
      context, collection, document, documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(documentId)
          .update(document);
    } catch (error) {
      Modal.show(context, 'Oops', 'Failed to update the $collection : $error');
    }
  }

  Future<List<Map<String, dynamic>>> getCollection(context, collection) async {
    try {
      CollectionReference challenges =
          FirebaseFirestore.instance.collection(collection);
      QuerySnapshot querySnapshot = await challenges.get();
      List<Map<String, dynamic>> dataList = [];

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        dataList.add(data);
      }

      return dataList;
    } catch (error) {
      Modal.show(context, 'Oops', 'Failed to get challenges : $error');

      return [];
    }
  }

  Stream<List<Map<String, dynamic>>> getCollectionStream(context, collection) {
    try {
      CollectionReference challenges =
          FirebaseFirestore.instance.collection(collection);
      Stream<QuerySnapshot> querySnapshotStream = challenges.snapshots();

      return querySnapshotStream.map((snapshot) {
        List<Map<String, dynamic>> dataList = [];

        for (QueryDocumentSnapshot documentSnapshot in snapshot.docs) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          dataList.add(data);
        }

        return dataList;
      });
    } catch (error) {
      Modal.show(context, 'Oops', 'Failed to get challenges : $error');

      return Stream.error(error);
    }
  }

  Future<void> deleteDocument(context, collection, documentId) async {
    try {
      final collectionReference =
          FirebaseFirestore.instance.collection(collection);
      await collectionReference.doc(documentId).delete();

      Navigator.pop(context);
      Navigator.pop(context);
    } on FirebaseException catch (error) {
      Modal.show(context, 'Oops', 'Failed to get challenges : $error');
    }
  }
}
