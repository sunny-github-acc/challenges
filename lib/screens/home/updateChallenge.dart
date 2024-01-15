import 'package:challenges/components/button.dart';
import 'package:flutter/material.dart';

import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/components/editable_date.dart';
import 'package:challenges/components/editable_options.dart';
import 'package:challenges/components/editable_text.dart';
import 'package:challenges/components/text.dart';

import 'package:challenges/services/cloud/cloud.dart';

class UpdateChallenge extends StatefulWidget {
  final Map<String, dynamic> collection;

  const UpdateChallenge({
    Key? key,
    required this.collection,
  }) : super(key: key);

  @override
  UpdateChallengeState createState() => UpdateChallengeState();
}

class UpdateChallengeState extends State<UpdateChallenge> {
  CloudService cloudService = CloudService();

  Map<String, dynamic> collection = {};

  Future<void Function(String p1)?> _save(dynamic input, String type) async {
    Map<String, dynamic> updatedData = {
      ...collection,
      type: input,
      'createdAt': DateTime.now()
    };

    _updateCollection(updatedData);

    return null;
  }

  _saveDate(DateTimeRange input) async {
    Map<String, dynamic> updatedData = {
      ...collection,
      'startDate': input.start,
      'endDate': input.end,
      'isUnlimited': false
    };

    _updateCollection(updatedData);
  }

  _updateCollection(Map<String, dynamic> updatedData) async {
    CloudService cloudService = CloudService();

    await cloudService.updateCollection(
        context, 'challenges', updatedData, updatedData['id']);
  }

  _delete() async {
    CloudService cloudService = CloudService();

    await cloudService.deleteDocument(
        context, 'challenges', widget.collection['id']);
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (details) {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: const CustomAppBar(),
          body: CustomColumn(children: [
            const TextCustom(
              text: 'Title',
              fontWeight: FontWeight.bold,
            ),
            EditableTextWidget(
              text: collection['title'],
              isTextRequired: true,
              onSave: (input) => _save(input, 'title'),
            ),
            const TextCustom(
              text: 'Description',
              fontWeight: FontWeight.bold,
            ),
            EditableTextWidget(
              text: collection['description'],
              onSave: (input) => _save(input, 'description'),
            ),
            const TextCustom(
              text: 'Period',
              fontWeight: FontWeight.bold,
            ),
            if (!collection['isUnlimited'])
              EditableDateWidget(
                text:
                    '${collection['startDate'].toDate().toString().substring(0, 10)} - ${collection['endDate'].toDate().toString().substring(0, 10)}',
                customStartDate: collection['startDate'].toDate(),
                customEndDate: collection['endDate'].toDate(),
                onSave: _saveDate,
              )
            else
              CustomColumn(children: [
                const TextCustom(text: 'Unlimited'),
                CustomButton(
                    onPressed: () => _save(false, 'isUnlimited'),
                    text: 'Set custom period',
                    size: ButtonSize.small,
                    type: ButtonType.primary)
              ]),
            if (!collection['isUnlimited'])
              CustomButton(
                  onPressed: () => _save(true, 'isUnlimited'),
                  text: 'Set period to infinite',
                  size: ButtonSize.small,
                  type: ButtonType.primary),
            const TextCustom(
              text: 'Consequence',
              fontWeight: FontWeight.bold,
            ),
            EditableTextWidget(
              text: collection['consequence'],
              onSave: (input) => _save(input, 'consequence'),
            ),
            const TextCustom(
              text: 'Visibility',
              fontWeight: FontWeight.bold,
            ),
            EditableOptionsWidget(
              option: collection['visibility'],
              options: const ['Public', 'Private'],
              onSave: (input) => _save(input, 'visibility'),
            ),
            CustomButton(
                onPressed: () => _delete(),
                text: 'DELETE CHALLENGE FOR EVER',
                size: ButtonSize.small,
                type: ButtonType.primary)
          ]),
        ));
  }
}
