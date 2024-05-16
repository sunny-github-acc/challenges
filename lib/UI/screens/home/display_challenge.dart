import 'package:flutter/material.dart';

import 'package:challenges/UI/screens/home/update_challenge.dart';

import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/challenge.dart';

import 'package:challenges/services/auth/auth.dart';
import 'package:challenges/services/cloud/cloud.dart';

class DisplayChallenge extends StatefulWidget {
  final Map<String, dynamic> collection;

  const DisplayChallenge({
    Key? key,
    required this.collection,
  }) : super(key: key);

  @override
  DisplayChallengeState createState() => DisplayChallengeState();
}

class DisplayChallengeState extends State<DisplayChallenge> {
  CloudService cloudService = CloudService();

  Map<String, dynamic> collection = {};
  bool isOwner = false;

  void _openUpdateChallenge(
      BuildContext context, Map<String, dynamic> collection) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateChallenge(
                collection: collection,
              )),
    );
  }

  @override
  void initState() {
    super.initState();

    collection = widget.collection;

    cloudService.getCollectionStream(context, 'challenges').listen((data) {
      setState(() {
        collection = data.firstWhere((d) => d['id'] == widget.collection['id']);
      });
    });

    AuthService authService = AuthService();
    Map user = authService.getUser();
    isOwner = user['email'] == collection['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          isOwner
              ? GestureDetector(
                  onTap: () => _openUpdateChallenge(context, collection),
                  child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 2.0),
                      width: 50,
                      height: 10,
                      child: const Icon(Icons.edit)),
                )
              : Container(),
        ],
      ),
      body: Challenge(collection: collection),
    );
  }
}
