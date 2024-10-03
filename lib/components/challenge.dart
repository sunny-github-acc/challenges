import 'package:challenges/components/column.dart';
import 'package:challenges/components/row.dart';
import 'package:challenges/components/text.dart';
import 'package:challenges/logic/bloc/collection/collection_bloc.dart';
import 'package:challenges/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Challenge extends StatelessWidget {
  final Map<String, dynamic> collection;

  const Challenge({
    Key? key,
    required this.collection,
  }) : super(key: key);

  openUserProfile(BuildContext context, String uid) {
    print('finish profile');
    print('finish profile');
  }

  @override
  Widget build(BuildContext context) {
    final description = collection['description'];
    final consequence = collection['consequence'];
    dynamic endDateDynamic = collection['endDate'];
    dynamic endDate =
        endDateDynamic is Timestamp ? endDateDynamic.toDate() : endDateDynamic;
    dynamic startDateDynamic = collection['startDate'];
    dynamic startDate = startDateDynamic is Timestamp
        ? startDateDynamic.toDate()
        : startDateDynamic;
    int daysSinceStart =
        DateTime.now().difference(DateTime.parse(startDate.toString())).inDays;
    int daysLeft =
        DateTime.parse(endDate.toString()).difference(DateTime.now()).inDays +
            1;
    Map user = authService.getUser();
    bool isOwner = user['email'] == collection['email'];

    return CustomColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: SpacingType.medium,
      children: [
        GestureDetector(
          onTap: () => openUserProfile(context, collection['uid']),
          child: CustomRow(
            spacing: SpacingType.small,
            flex: const [0, 1],
            children: [
              ClipOval(
                child: collection['photoURL'] != null
                    ? Image.network(
                        collection['photoURL'],
                        height: 34,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/avatar.png',
                        height: 34,
                        fit: BoxFit.cover,
                        color: colorMap['black'],
                      ),
              ),
              CustomText(
                text: collection['displayName'],
                // fontWeight: FontWeight.bold,
                fontSize: FontSizeType.xlarge,
              ),
            ],
          ),
        ),
        CustomText(
          text: collection['title'],
          fontSize: FontSizeType.large,
        ),
        if (description != '')
          CustomRow(
            spacing: SpacingType.small,
            flex: const [0, 1],
            children: [
              Image.asset(
                'assets/description.png',
                width: 24,
                height: 24,
              ),
              CustomText(
                text: description,
              )
            ],
          ),
        if (consequence != '')
          CustomRow(
            spacing: SpacingType.small,
            flex: const [0, 1],
            children: [
              Image.asset(
                'assets/consequence.png',
                width: 24,
                height: 24,
              ),
              CustomText(
                text: consequence,
              ),
            ],
          ),
        CustomRow(
          spacing: SpacingType.small,
          flex: const [0, 1],
          children: [
            Image.asset(
              'assets/days.png',
              width: 24,
              height: 24,
            ),
            CustomText(
              text: collection['duration'] == 'Infinite'
                  ? 'Infinite Challenge 🤩\n$daysSinceStart days since start'
                  : '${collection["duration"]}ly challenge ends in $daysLeft days - $daysSinceStart days since start',
            ),
          ],
        ),
        if (isOwner)
          CustomRow(
            spacing: SpacingType.small,
            children: [
              Image.asset(
                collection['visibility'] == 'Only me'
                    ? 'assets/private.png'
                    : 'assets/public.png',
                width: 24,
                height: 24,
              ),
              CustomText(
                text: '${collection['visibility']} challenge',
              ),
            ],
          ),
        if (collection['isFinished'])
          CustomRow(
            spacing: SpacingType.small,
            flex: const [0, 1],
            children: [
              Image.asset(
                collection['isSuccess']
                    ? 'assets/completed.png'
                    : 'assets/failed.png',
                width: 24,
                height: 24,
                color: collection['isSuccess']
                    ? colorMap['green']
                    : colorMap['red'],
              ),
              CustomText(
                text: collection['isSuccess']
                    ? 'Challenge Completed'
                    : 'Challenge Failed',
              ),
            ],
          ),
      ],
    );
  }
}
