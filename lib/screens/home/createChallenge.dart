import 'package:challenges/components/column.dart';
import 'package:challenges/components/row.dart';
import 'package:flutter/material.dart';

import 'package:challenges/services/cloud/cloud.dart';
import 'package:challenges/services/auth/auth.dart';

import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/modal.dart';
import 'package:challenges/components/input.dart';
import 'package:challenges/components/text.dart';
import 'package:challenges/components/date.dart';

class CreateChallenge extends StatefulWidget {
  const CreateChallenge({super.key});

  @override
  State<CreateChallenge> createState() => _CreateChallenge();
}

class _CreateChallenge extends State<CreateChallenge> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController consequenceController = TextEditingController();

  String consequence = '';
  String duration = 'Week';
  String visibility = 'Public';
  bool isTitle = true;
  bool isDuration = true;
  bool isLoading = false;
  DateTime today = DateTime.now();
  DateTime customStartDate = DateTime.now();
  DateTime? customEndDate;

  Future<void> _save(context) async {
    AuthService authService = AuthService();

    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
    String consequence = consequenceController.text.trim();

    Map user = authService.getUser();

    DateTime endDate = _getEndDate(duration, customEndDate);

    Map<String, dynamic> document = {
      ...user,
      'title': title,
      'description': description,
      'createdAt': today,
      'startDate': customStartDate,
      'endDate': endDate,
      'isUnlimited': duration == 'Unlimited',
      'consequence': consequence,
      'visibility': visibility
    };

    setState(() {
      isTitle = title.isNotEmpty;
    });

    if (!isTitle || !isDuration) {
      return Modal.show(context, 'Oops', 'Please fill out all input fields');
    }

    setState(() {
      isLoading = true;
    });

    CloudService cloudService = CloudService();
    await cloudService.setCollection(context, 'challenges', document);
    Navigator.pop(context);

    setState(() {
      isLoading = false;
    });
  }

  void _handleDuration(BuildContext context, String durationParam) {
    setState(() {
      duration = durationParam;
    });
  }

  void _handleVisibility(BuildContext context, String visibilityParam) {
    setState(() {
      visibility = visibilityParam;
    });
  }

  DateTime _getEndDate(duration, customDate) {
    if (duration == 'Custom') {
      return customDate;
    } else {
      return DateTime.utc(
        today.year + (duration == 'Year' ? 1 : 0),
        today.month + (duration == 'Month' ? 1 : 0),
        today.day + (duration == 'Week' || duration == 'Unlimited' ? 7 : 0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Add a challenge',
          actions: [
            CustomButton(
              text: 'Save',
              size: ButtonSize.small,
              isLoading: isLoading,
              onPressed: () => _save(context),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: ContainerGradient(
            padding: 8,
            child: CustomColumn(
              children: [
                CustomInput(
                  title: 'Title',
                  labelText: 'Enter Title',
                  hintText: 'Enter the title of your challenge',
                  controller: titleController,
                  disabled: !isTitle,
                ),
                CustomInput(
                  title: 'Description',
                  labelText: 'Enter Description',
                  hintText: 'Enter a specific description of your challenge',
                  controller: descriptionController,
                  isTall: true,
                ),
                const TextCustom(text: 'The period of the challenge'),
                Center(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          children: [
                            CustomButton(
                                onPressed: () =>
                                    _handleDuration(context, 'Week'),
                                text: 'Week',
                                size: ButtonSize.small,
                                type: duration == 'Week'
                                    ? ButtonType.primary
                                    : ButtonType.secondary),
                            CustomButton(
                                onPressed: () =>
                                    _handleDuration(context, 'Month'),
                                text: 'Month',
                                size: ButtonSize.small,
                                type: duration == 'Month'
                                    ? ButtonType.primary
                                    : ButtonType.secondary),
                            CustomButton(
                                onPressed: () =>
                                    _handleDuration(context, 'Year'),
                                text: 'Year',
                                size: ButtonSize.small,
                                type: duration == 'Year'
                                    ? ButtonType.primary
                                    : ButtonType.secondary),
                            CustomButton(
                                onPressed: () =>
                                    _handleDuration(context, 'Custom'),
                                text: 'Custom',
                                size: ButtonSize.small,
                                type: duration == 'Custom'
                                    ? ButtonType.primary
                                    : ButtonType.secondary),
                            CustomButton(
                                onPressed: () =>
                                    _handleDuration(context, 'Unlimited'),
                                text: 'Unlimited',
                                size: ButtonSize.small,
                                type: duration == 'Unlimited'
                                    ? ButtonType.primary
                                    : ButtonType.secondary),
                            duration == 'Custom'
                                ? CustomDateRangePicker(
                                    customStartDate: customStartDate,
                                    customEndDate: customEndDate,
                                    onSelected: (date) {
                                      customStartDate = date.start;
                                      customEndDate = date.end;
                                    },
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ))),
                const TextCustom(
                    text:
                        'What will be the consequence of completed of failed challenge?'),
                CustomInput(
                  labelText: 'Consequence',
                  hintText: 'Enter a specific consequence of your challenge',
                  controller: consequenceController,
                  isTall: true,
                ),
                const TextCustom(text: 'Public or private challenge?'),
                CustomRow(children: [
                  CustomButton(
                      onPressed: () => _handleVisibility(context, 'Public'),
                      text: 'Public',
                      size: ButtonSize.small,
                      type: visibility == 'Public'
                          ? ButtonType.primary
                          : ButtonType.secondary),
                  CustomButton(
                      onPressed: () => _handleVisibility(context, 'Private'),
                      text: 'Private',
                      size: ButtonSize.small,
                      type: visibility == 'Private'
                          ? ButtonType.primary
                          : ButtonType.secondary),
                ]),
              ],
            ),
          ),
        ));
  }
}
