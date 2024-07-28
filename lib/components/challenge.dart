import 'package:challenges/components/button.dart';
import 'package:challenges/components/row.dart';
import 'package:challenges/components/text.dart';
import 'package:challenges/logic/bloc/collection/collection_bloc.dart';
import 'package:challenges/logic/bloc/collection/collection_events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Challenge extends StatelessWidget {
  final Map<String, dynamic> collection;
  final String parent;

  const Challenge({
    Key? key,
    required this.collection,
    required this.parent,
  }) : super(key: key);

  void _openUserProfile(BuildContext context, String uid) {
    print('finish profile');
    print('finish profile');
  }

  void setStatus(BuildContext context, bool status) {
    Map<String, dynamic> updatedCollection = {
      'isCompleted': status,
    };

    BlocProvider.of<CollectionBloc>(context).add(
      CollectionEventUpdateCollection(
        collection: updatedCollection,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final description = collection['description'];
    final consequence = collection['consequence'];
    dynamic endDateDynamic = collection['endDate'];
    dynamic endDate =
        endDateDynamic is Timestamp ? endDateDynamic.toDate() : endDateDynamic;
    String endDateString = endDate.toString().substring(0, 10);
    dynamic createdAtDynamic = collection['createdAt'];
    dynamic createdAt = createdAtDynamic is Timestamp
        ? createdAtDynamic.toDate()
        : createdAtDynamic;
    int daysSinceStart =
        DateTime.now().difference(DateTime.parse(createdAt.toString())).inDays;
    int daysLeft =
        DateTime.parse(endDate.toString()).difference(DateTime.now()).inDays +
            1;
    Map user = authService.getUser();
    bool isOwner = user['email'] == collection['email'];
    bool showSetStatus = isOwner && parent == 'display_challenge';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomRow(children: [
          GestureDetector(
            onTap: () => _openUserProfile(context, collection['uid']),
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 12.0,
              ),
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
                      ),
                    ),
            ),
          ),
          TextCustom(
            text: collection['displayName'],
            fontWeight: FontWeight.bold,
          ),
        ]),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    ? 'Unlimited ($daysSinceStart days since start)'
                    : '$endDateString ($daysLeft days left)'),
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
            TextCustom(
              text: collection['visibility'],
            ),
            collection['isCompleted'] != null
                ? const TextCustom(
                    text: 'Status',
                    fontWeight: FontWeight.bold,
                  )
                : Container(),
            collection['isCompleted'] != null
                ? TextCustom(
                    text: collection['isCompleted'] == true
                        ? 'Completed'
                        : 'Failed',
                  )
                : Container(),
            if (showSetStatus)
              const TextCustom(
                text: 'Set status',
                fontWeight: FontWeight.bold,
              ),
            if (showSetStatus)
              CustomButton(
                onPressed: () => setStatus(context, true),
                text: 'Challenge Completed',
                size: ButtonSize.small,
                type: ButtonType.primary,
              ),
            if (showSetStatus)
              CustomButton(
                onPressed: () => setStatus(context, false),
                text: 'Challenge Failed',
                size: ButtonSize.small,
                type: ButtonType.secondary,
              )
          ],
        ),
      ],
    );
  }
}
