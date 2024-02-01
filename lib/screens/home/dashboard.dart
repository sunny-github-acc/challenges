import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:challenges/screens/home/displayChallenge.dart';

import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/card.dart';
import 'package:challenges/components/challenge.dart';

import 'package:challenges/services/cloud/cloud.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  CloudService cloudService = CloudService();

  List<Map<String, dynamic>> collection = [];

  @override
  void initState() {
    super.initState();

    _loadCollectionData();

    cloudService.getCollectionStream(context, 'challenges', {
      'endDateIsAfter': DateTime.now(),
      'isUnlimited': true,
    }).listen((data) {
      List<Map<String, dynamic>> sortedData = data
        ..sort((a, b) {
          DateTime dateTimeA = (a['createdAt'] as Timestamp).toDate();
          DateTime dateTimeB = (b['createdAt'] as Timestamp).toDate();

          return dateTimeB.compareTo(dateTimeA);
        });

      setState(() {
        collection = sortedData;
      });
    });
  }

  Future<void> _loadCollectionData() async {
    try {
      List<Map<String, dynamic>> data =
          await cloudService.getCollectionWithQuery(context, 'challenges', {
        'endDateIsGreater': DateTime.now(),
        'isUnlimited': true,
      });
      List<Map<String, dynamic>> sortedData = data
        ..sort((a, b) {
          DateTime dateTimeA = (a['createdAt'] as Timestamp).toDate();
          DateTime dateTimeB = (b['createdAt'] as Timestamp).toDate();

          return dateTimeB.compareTo(dateTimeA);
        });

      setState(() {
        collection = sortedData;
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error loading collection data: $error');
      }
    }
  }

  void _openChallenge(BuildContext context, Map<String, dynamic> collection) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DisplayChallenge(
                collection: collection,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Ongoing global challenges',
        fontSize: 20,
      ),
      body: ListView.builder(
        itemCount: collection.length,
        itemBuilder: (context, index) {
          return CustomCard(
              onPressed: () => _openChallenge(context, collection[index]),
              child: Challenge(
                collection: collection[index],
              ));
        },
      ),
    );
  }
}
