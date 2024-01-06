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

  Future<void Function(String p1)?> _save(String input, String type) async {
    Map<String, dynamic> updatedData = {...collection, type: input};

    _updateCollection(updatedData);

    return null;
  }

  _saveDate(DateTime input) async {
    Map<String, dynamic> updatedData = {...collection, 'endDate': input};

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
              text: 'End date',
              fontWeight: FontWeight.bold,
            ),
            EditableDateWidget(
              text: collection['endDate'].toDate().toString().substring(0, 16),
              customEndDate: collection['endDate'].toDate(),
              onSave: _saveDate,
            ),
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
