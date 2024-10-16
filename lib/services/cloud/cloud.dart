import 'package:cloud_firestore/cloud_firestore.dart';

enum QueryType {
  noQuery,
  filter,
  tribes,
  user,
}

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
      rethrow;
    }
  }

  Future<void> updateCollection(collection, document, documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('challenges')
          .doc(collection)
          .collection(collection)
          .doc(documentId)
          .update(document);
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDocument(collection, id) async {
    try {
      final DocumentReference<Map<String, dynamic>> ref = FirebaseFirestore
          .instance
          .collection('challenges')
          .doc(collection)
          .collection(collection)
          .doc(id);

      DocumentSnapshot<Map<String, dynamic>> querySnapshot = await ref.get();
      Map<String, dynamic>? data = querySnapshot.data();

      if (data != null) {
        return data;
      } else {
        throw 'no-data-found';
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getCollection(
    collection,
    Map<String, dynamic>? query, {
    QueryType queryType = QueryType.noQuery,
  }) async {
    try {
      CollectionReference challenges = FirebaseFirestore.instance
          .collection('challenges')
          .doc(collection)
          .collection(collection);

      List<Map<String, dynamic>> dataList = [];

      final queryBuilders = {
        QueryType.noQuery: () => challenges,
        QueryType.filter: () => getFilterSettingsQueryBuilder(
              challenges,
              query,
            ),
        QueryType.tribes: () => getTribesQueryBuilder(challenges, query),
        QueryType.user: () => getUserQueryBuilder(challenges, query),
      };

      Query<Object?>? queryBuilder = queryBuilders[queryType]!();

      QuerySnapshot<Object?>? querySnapshot = await queryBuilder.get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        data['id'] = documentSnapshot.id;
        dataList.add(data);
      }

      return dataList;
    } catch (error) {
      rethrow;
    }
  }

  Query<Object?> getFilterSettingsQueryBuilder(
    challenges,
    query,
  ) {
    Map<String, dynamic> visibility = query['visibility'];
    List<String> visibilityKeys = visibility.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();
    bool isFinished = query['isFinished'];
    bool isIncludeFinished = query['isIncludeFinished'];
    String duration = query['duration'];

    if (visibilityKeys.isEmpty) {
      return challenges.where(
        FieldPath.documentId,
        isEqualTo: 'returnEmptyResult',
      );
    }

    if (!isIncludeFinished) {
      Query challengesQuery = challenges
          .where('visibility', whereIn: visibilityKeys)
          .where('isFinished', isEqualTo: false);

      if (duration != 'All') {
        challengesQuery =
            challengesQuery.where('duration', isEqualTo: duration);
      }

      return challengesQuery;
    } else if (isFinished) {
      Query challengesQuery = challenges
          .where('visibility', whereIn: visibilityKeys)
          .where('isFinished', isEqualTo: true);

      if (duration != 'All') {
        challengesQuery = challengesQuery.where(
          'duration',
          isEqualTo: duration,
        );
      }

      return challengesQuery;
    }

    Query challengesQuery = challenges.where(
      'visibility',
      whereIn: visibilityKeys,
    );

    if (duration != 'All') {
      challengesQuery = challengesQuery.where('duration', isEqualTo: duration);
    }

    return challengesQuery;
  }

  Query<Object?> getTribesQueryBuilder(challenges, query) {
    return challenges.where('members', arrayContains: query['uid']);
  }

  Query<Object?> getUserQueryBuilder(challenges, query) {
    return challenges.where('uid', isEqualTo: query['uid']);
  }

  Stream<List<Map<String, dynamic>>> getCollectionWithFilterSettingsStream(
    collection,
    Map<String, dynamic> query,
    QueryType queryType,
  ) {
    try {
      FirebaseFirestore firebase = FirebaseFirestore.instance;
      CollectionReference challenges = firebase
          .collection('challenges')
          .doc(collection)
          .collection(collection);

      Stream<QuerySnapshot> querySnapshotStream = getFilterSettingsQueryBuilder(
        challenges,
        query,
      ).snapshots();

      return querySnapshotStream.map((querySnapshot) {
        List<Map<String, dynamic>> dataList = [];

        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          data['id'] = documentSnapshot.id;
          dataList.add(data);
        }

        return dataList;
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteDocument(String collection, String documentId) async {
    try {
      final collectionReference = FirebaseFirestore.instance
          .collection('challenges')
          .doc(collection)
          .collection(collection);
      await collectionReference.doc(documentId).delete();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteDocuments(collection, query) async {
    try {
      QuerySnapshot collectionReference = await FirebaseFirestore.instance
          .collection('challenges')
          .doc(collection)
          .collection(collection)
          .where('uid', isEqualTo: query['uid'])
          .get();

      for (QueryDocumentSnapshot doc in collectionReference.docs) {
        await doc.reference.delete();
      }
    } catch (error) {
      rethrow;
    }
  }
}
