import 'package:cloud_firestore/cloud_firestore.dart';

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

  Query<Object?> getQueryBuilder(
    challenges,
    query,
  ) {
    bool isPrivate = query['isPrivate'];
    bool isFinished = query['isFinished'];
    bool isIncludeFinished = query['isIncludeFinished'];
    String uid = query['uid'];
    List<String> duration = query['duration'] == 'All'
        ? ['Week', 'Month', 'Year', 'Infinite']
        : [query['duration']];

    if (isPrivate) {
      if (!isIncludeFinished) {
        return challenges
            .where('uid', isEqualTo: uid)
            .where('isFinished', isEqualTo: false)
            .where('duration', whereIn: duration);
      } else if (isFinished) {
        return challenges
            .where('uid', isEqualTo: uid)
            .where('isFinished', isEqualTo: true)
            .where('duration', whereIn: duration);
      }

      return challenges
          .where('uid', isEqualTo: uid)
          .where('duration', whereIn: duration);
    } else {
      if (!isIncludeFinished) {
        return challenges
            .where('isFinished', isEqualTo: false)
            .where('duration', whereIn: duration);
      } else if (isFinished) {
        return challenges
            .where('isFinished', isEqualTo: true)
            .where('duration', whereIn: duration);
      }
    }

    return challenges.where('duration', whereIn: duration);
  }

  Future<List<Map<String, dynamic>>> getCollectionWithFilterSettingsQuery(
    collection,
    Map<String, dynamic> query,
  ) async {
    try {
      CollectionReference challenges = FirebaseFirestore.instance
          .collection('challenges')
          .doc(collection)
          .collection(collection);

      List<Map<String, dynamic>> dataList = [];

      QuerySnapshot<Object?>? querySnapshot = await getQueryBuilder(
        challenges,
        query,
      ).get();
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

  Future<List<Map<String, dynamic>>> getCollection(
    collection,
  ) async {
    try {
      CollectionReference challenges = FirebaseFirestore.instance
          .collection('challenges')
          .doc(collection)
          .collection(collection);

      List<Map<String, dynamic>> dataList = [];

      QuerySnapshot<Object?>? querySnapshot = await challenges.get();

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

  Stream<List<Map<String, dynamic>>> getCollectionWithFilterSettingsStream(
    collection,
    Map<String, dynamic> query,
  ) {
    try {
      FirebaseFirestore firebase = FirebaseFirestore.instance;
      CollectionReference challenges = firebase
          .collection('challenges')
          .doc(collection)
          .collection(collection);

      Stream<QuerySnapshot> querySnapshotStream = getQueryBuilder(
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

  Future<void> deleteDocument(collection, documentId) async {
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
}
