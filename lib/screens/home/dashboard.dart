import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:challenges/components/text.dart';
import 'package:challenges/components/row.dart';

import 'package:challenges/services/cloud/cloud.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  CloudService cloudService = CloudService();

  List<Map<String, dynamic>> collectionData = [];

  @override
  void initState() {
    super.initState();

    _loadCollectionData();

    cloudService.getCollectionStream(context, 'challenges').listen((data) {
      setState(() {
        collectionData = data;
      });
    });
  }

  Future<void> _loadCollectionData() async {
    try {
      List<Map<String, dynamic>> data =
          await cloudService.getCollection(context, 'challenges');

      setState(() {
        collectionData = data;
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error loading collection data: $error');
      }
    }
  }

  Future<void> _openUserProfile() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Ongoing global challenges',
        fontSize: 20,
      ),
      body: ListView.builder(
        itemCount: collectionData.length,
        itemBuilder: (context, index) {
          final description = collectionData[index]['description'];
          final consequence = collectionData[index]['consequence'];

          return CustomCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                CustomRow(children: [
                  GestureDetector(
                    onTap: _openUserProfile,
                    child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 12.0),
                        child: collectionData[index]['photoURL'] != null
                            ? ClipOval(
                                child: Image.network(
                                collectionData[index]['photoURL']!,
                                height: 20,
                                fit: BoxFit.cover,
                              ))
                            : Image.asset(
                                'assets/grow.png',
                                height: 20.0,
                              )),
                  ),
                  TextCustom(
                    text: collectionData[index]['displayName'],
                    fontWeight: FontWeight.bold,
                  ),
                ]),
                const TextCustom(
                  text: 'Title',
                  fontWeight: FontWeight.bold,
                ),
                Text(collectionData[index]['title']),
                if (description != '') ...[
                  const TextCustom(
                    text: 'Description',
                    fontWeight: FontWeight.bold,
                  ),
                  Text(description)
                ],
                const TextCustom(
                  text: 'End date',
                  fontWeight: FontWeight.bold,
                ),
                Text(collectionData[index]['endDate']
                    .toDate()
                    .toString()
                    .substring(0, 16)),
                if (consequence != '') ...[
                  const TextCustom(
                    text: 'Consequence',
                    fontWeight: FontWeight.bold,
                  ),
                  Text(consequence)
                ],
              ]));
        },
      ),
    );
  }
}
