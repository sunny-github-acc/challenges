import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:challenges/components/modal.dart';

class CloudService {
  Future<void> setCollection(context, collection, document) async {
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .add(document)
          .then((value) => print('The challenge is added'));

      Navigator.pop(context);
      Modal.show(context, 'Congrats!', 'The challenge is added');
    } catch (error) {
      Modal.show(context, 'Oops', 'Failed to add the challenge : $error');
    }
  }

  Future<List<Map<String, dynamic>>> getCollection(context, collection) async {
    try {
      CollectionReference challenges = FirebaseFirestore.instance.collection(collection);
      QuerySnapshot querySnapshot = await challenges.get();
      List<Map<String, dynamic>> dataList = [];

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        dataList.add(data);
      }

      return dataList;
    } catch (error) {
      Modal.show(context, 'Oops', 'Failed to get challenges : $error');

      return [];
    }
  }
}

