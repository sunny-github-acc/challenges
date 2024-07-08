import 'package:challenges/components/row.dart';
import 'package:challenges/components/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Challenge extends StatelessWidget {
  final Map<String, dynamic> collection;

  const Challenge({
    Key? key,
    required this.collection,
  }) : super(key: key);

  void _openUserProfile(BuildContext context, String uid) {}

  @override
  Widget build(BuildContext context) {
    final description = collection['description'];
    final consequence = collection['consequence'];
    dynamic endDateDynamic = collection['endDate'];
    dynamic endDate =
        endDateDynamic is Timestamp ? endDateDynamic.toDate() : endDateDynamic;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CustomRow(children: [
        GestureDetector(
          onTap: () => _openUserProfile(context, collection['uid']),
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 12.0),
              child: collection['photoURL'] == null
                  ? Image.asset(
                      'assets/grow.png',
                      height: 20.0,
                    )
                  : ClipOval(
                      child: Image.network(
                      collection['photoURL'],
                      height: 20,
                      fit: BoxFit.cover,
                    ))),
        ),
        TextCustom(
          text: collection['displayName'],
          fontWeight: FontWeight.bold,
        ),
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const TextCustom(
          text: 'Title',
          fontWeight: FontWeight.bold,
        ),
        TextCustom(text: collection['title']),
        if (description != '') ...[
          const TextCustom(
            text: 'Description',
            fontWeight: FontWeight.bold,
          ),
          TextCustom(text: description)
        ],
        const TextCustom(
          text: 'Period',
          fontWeight: FontWeight.bold,
        ),
        TextCustom(
            text: collection['isUnlimited'] == true
                ? 'Unlimited (${DateTime.now().difference(DateTime.parse(collection['createdAt'].toDate().toString())).inDays} days since start)'
                : '${endDate.toString().substring(0, 10)} (${DateTime.parse(endDate.toString()).difference(DateTime.now()).inDays + 1} days left)'),
        if (consequence != '') ...[
          const TextCustom(
            text: 'Consequence',
            fontWeight: FontWeight.bold,
          ),
          TextCustom(text: consequence)
        ],
        const TextCustom(
          text: 'Visibility',
          fontWeight: FontWeight.bold,
        ),
        TextCustom(text: collection['visibility'])
      ]),
    ]);
  }
}
