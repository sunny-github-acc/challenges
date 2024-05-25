import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:challenges/components/modal.dart';

class CloudService {
  Future<void> setCollection(collection, document, {customDocumentId}) async {
    try {
      final finalDocument = FirebaseFirestore.instance
          .collection('challenges')
          .doc(collection)
          .collection(collection);
      if (customDocumentId != null) {
        await finalDocument.doc(customDocumentId).set(document);
      } else {
        await finalDocument.add(document);
      }
    } catch (error) {
      // Modal.show(context, 'Oops', 'Failed to add the $collection : $error');
    }
  }

  Future<void> updateCollection(
      context, collection, document, documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('challenges')
          .doc(collection)
          .collection(collection)
          .doc(documentId)
          .update(document);
    } catch (error) {
      Modal.show(context, 'Oops', 'Failed to update the $collection : $error');
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getDocument(
      collection, id) async {
    try {
      final DocumentReference<Map<String, dynamic>> ref = FirebaseFirestore
          .instance
          .collection('challenges')
          .doc(collection)
          .collection(collection)
          .doc(id);

      DocumentSnapshot<Map<String, dynamic>> querySnapshot = await ref.get();

      return querySnapshot;
    } catch (error) {
      // Modal.show(context, 'Oops', 'Failed to get challenges : $error');

      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getCollectionWithQuery(
      context, collection, Map<String, dynamic> queryOptions) async {
    try {
      CollectionReference challenges = FirebaseFirestore.instance
          .collection('challenges')
          .doc(collection)
          .collection(collection);

      Query endDateQuery = challenges;
      Query isUnlimitedQuery = challenges;
      late QuerySnapshot<Object?>? endDateQuerySnapshot;
      late QuerySnapshot<Object?>? isUnlimitedQuerySnapshot;
      List<Map<String, dynamic>> dataList = [];

      if (queryOptions.containsKey('endDateIsGreater')) {
        DateTime date = queryOptions['endDateIsGreater']!;
        endDateQuery = endDateQuery.where('endDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(date));
        endDateQuerySnapshot = await endDateQuery.get();
        for (QueryDocumentSnapshot documentSnapshot
            in endDateQuerySnapshot.docs) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          data['id'] = documentSnapshot.id;

          dataList.add(data);
        }
      }

      if (queryOptions.containsKey('isUnlimited')) {
        isUnlimitedQuery =
            isUnlimitedQuery.where('isUnlimited', isEqualTo: true);
        isUnlimitedQuerySnapshot = await isUnlimitedQuery.get();
        for (QueryDocumentSnapshot documentSnapshot
            in isUnlimitedQuerySnapshot.docs) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          data['id'] = documentSnapshot.id;

          dataList.add(data);
        }
      }

      return removeDuplicates(dataList);
    } catch (error) {
      Modal.show(context, 'Oops', 'Failed to get challenges : $error');

      return [];
    }
  }

  List<Map<String, dynamic>> removeDuplicates(
      List<Map<String, dynamic>> originalList) {
    Set<String> uniqueIds = {};
    List<Map<String, dynamic>> resultList = [];

    for (Map<String, dynamic> item in originalList) {
      String id = item['id'];

      if (!uniqueIds.contains(id)) {
        uniqueIds.add(id);
        resultList.add(item);
      }
    }

    return resultList;
  }

  Stream<List<Map<String, dynamic>>> getCollectionStream(context, collection,
      [Map<String, dynamic>? queryOptions]) {
    try {
      CollectionReference challenges = FirebaseFirestore.instance
          .collection('challenges')
          .doc(collection)
          .collection(collection);

      Stream<QuerySnapshot> querySnapshotStream = challenges.snapshots();

      return querySnapshotStream.map((snapshot) {
        List<Map<String, dynamic>> dataList = [];

        void addValues(dynamic documentSnapshot) {
          final Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;

          dataList.add(data);
        }

        for (dynamic documentSnapshot in snapshot.docs) {
          if (queryOptions == null) {
            addValues(documentSnapshot);
          } else {
            bool isUnlimited = queryOptions.containsKey('isUnlimited') &&
                queryOptions['isUnlimited'] == true;
            bool isAfter = queryOptions.containsKey('endDateIsAfter') &&
                documentSnapshot
                    .data()['endDate']
                    .toDate()
                    .isAfter(queryOptions['endDateIsAfter']);
            bool isBefore = queryOptions.containsKey('endDateIsBefore') &&
                documentSnapshot
                    .data()['endDate']
                    .toDate()
                    .isBefore(queryOptions['endDateIsBefore']);
            bool isEmpty = !queryOptions.containsKey('endDateIsAfter') &&
                !queryOptions.containsKey('endDateIsBefore');

            if (isUnlimited || isAfter || isBefore || isEmpty) {
              addValues(documentSnapshot);
            }
          }
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
      final collectionReference = FirebaseFirestore.instance
          .collection('challenges')
          .doc(collection)
          .collection(collection);
      await collectionReference.doc(documentId).delete();

      Navigator.pop(context);
      Navigator.pop(context);
    } on FirebaseException catch (error) {
      Modal.show(context, 'Oops', 'Failed to get challenges : $error');
    }
  }
}
