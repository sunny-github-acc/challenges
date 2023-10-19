import 'package:flutter/material.dart';

import 'package:challenges/services/cloud/cloud.dart';
import 'package:challenges/services/auth/auth.dart';

import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/modal.dart';
import 'package:challenges/components/input.dart';
import 'package:challenges/components/card.dart';
import 'package:challenges/components/text.dart';

class CreateChallenge extends StatefulWidget {
  const CreateChallenge({super.key});

  @override
  State<CreateChallenge> createState() => _CreateChallenge();
}

class _CreateChallenge extends State<CreateChallenge> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController measureNumberController = TextEditingController();
  final TextEditingController measureTextController = TextEditingController();
  final TextEditingController timeframeNumberController =
      TextEditingController();
  final TextEditingController consequenceController = TextEditingController();

  String measure = 'Once';
  String timeframe = 'Week';
  String consequence = '';
  bool isTitle = true;
  bool isMeasure = true;
  bool isTimeframe = true;

  Future<void> _save(context) async {
    AuthService authService = AuthService();

    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
    String measureNumber = measureNumberController.text.trim();
    String measureText = measureTextController.text.trim();
    String timeframeNumber = timeframeNumberController.text.trim();
    String consequence = consequenceController.text.trim();

    Map user = authService.getUser();

    Map<String, dynamic> document = {
      ...user,
      'title': title,
      'description': description,
      'measure': measure,
      'measureNumber': measureNumber,
      'measureText': measureText,
      'timeframeNumber': timeframeNumber,
      'consequence': consequence
    };

    setState(() {
      isTitle = title.isNotEmpty;
      isMeasure = measure == 'Once' ||
          measureNumber.isNotEmpty ||
          measureText.isNotEmpty;
      isTimeframe = timeframe != 'Custom' || timeframeNumber.isNotEmpty;
    });

    if (!isTitle || !isMeasure || !isTimeframe) {
      return Modal.show(context, 'Oops', 'Please fill out all input fields');
    }

    CloudService cloudService = CloudService();
    await cloudService.setCollection(context, 'challenges', document);
  }

  void _handleMeasure(BuildContext context, String measurement) {
    setState(() {
      measure = measurement;
    });
  }

  void _handleTimeframe(BuildContext context, String length) {
    setState(() {
      timeframe = length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Add a challenge',
          actions: [
            ButtonCustom(
              onPressed: () => _save(context),
              text: 'Save',
              size: ButtonSize.small,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ContainerGradient(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InputCustom(
                        labelText: 'Title',
                        hintText: 'Enter the title of your challenge',
                        controller: titleController,
                        disabled: !isTitle,
                      ),
                      InputCustom(
                        labelText: 'Description',
                        hintText:
                            'Enter a specific description of your challenge',
                        controller: descriptionController,
                        isTall: true,
                      ),
                      ReusableCard(
                        child: Column(children: [
                          Center(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextCustom(text: 'Measure'),
                            ),
                          ),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              ButtonCustom(
                                  onPressed: () =>
                                      _handleMeasure(context, 'Once'),
                                  text: 'Once',
                                  size: ButtonSize.small,
                                  type: measure == 'Once'
                                      ? ButtonType.primary
                                      : ButtonType.secondary),
                              ButtonCustom(
                                  onPressed: () =>
                                      _handleMeasure(context, 'Times'),
                                  text: 'Times',
                                  size: ButtonSize.small,
                                  type: measure == 'Times'
                                      ? ButtonType.primary
                                      : ButtonType.secondary),
                              ButtonCustom(
                                  onPressed: () =>
                                      _handleMeasure(context, 'Points'),
                                  text: 'Points',
                                  size: ButtonSize.small,
                                  type: measure == 'Points'
                                      ? ButtonType.primary
                                      : ButtonType.secondary),
                              ButtonCustom(
                                  onPressed: () =>
                                      _handleMeasure(context, 'Event'),
                                  text: 'Event',
                                  size: ButtonSize.small,
                                  type: measure == 'Event'
                                      ? ButtonType.primary
                                      : ButtonType.secondary),
                            ],
                          ),
                          measure == 'Times' || measure == 'Points'
                              ? Center(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: InputCustom(
                                      isInputTypeText: false,
                                      labelText: measure,
                                      hintText:
                                          'Enter the length of your challenge',
                                      controller: measureNumberController,
                                      disabled: !isMeasure,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          measure == 'Event'
                              ? Center(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: InputCustom(
                                      labelText: measure,
                                      hintText:
                                          'Enter the amplitude of your challenge',
                                      controller: measureTextController,
                                      disabled: !isMeasure,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ]),
                      ),
                      ReusableCard(
                        child: Column(children: [
                          Center(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextCustom(text: 'Timeframe'),
                            ),
                          ),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              ButtonCustom(
                                  onPressed: () =>
                                      _handleTimeframe(context, 'Week'),
                                  text: 'Week',
                                  size: ButtonSize.small,
                                  type: timeframe == 'Week'
                                      ? ButtonType.primary
                                      : ButtonType.secondary),
                              ButtonCustom(
                                  onPressed: () =>
                                      _handleTimeframe(context, 'Month'),
                                  text: 'Month',
                                  size: ButtonSize.small,
                                  type: timeframe == 'Month'
                                      ? ButtonType.primary
                                      : ButtonType.secondary),
                              ButtonCustom(
                                  onPressed: () =>
                                      _handleTimeframe(context, 'Year'),
                                  text: 'Year',
                                  size: ButtonSize.small,
                                  type: timeframe == 'Year'
                                      ? ButtonType.primary
                                      : ButtonType.secondary),
                              ButtonCustom(
                                  onPressed: () =>
                                      _handleTimeframe(context, 'Custom'),
                                  text: 'Custom',
                                  size: ButtonSize.small,
                                  type: timeframe == 'Custom'
                                      ? ButtonType.primary
                                      : ButtonType.secondary),
                              ButtonCustom(
                                  onPressed: () =>
                                      _handleTimeframe(context, 'Forever'),
                                  text: 'Forever',
                                  size: ButtonSize.small,
                                  type: timeframe == 'Forever'
                                      ? ButtonType.primary
                                      : ButtonType.secondary),
                              timeframe == 'Custom'
                                  ? Center(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: InputCustom(
                                          labelText: 'Add calendar',
                                          hintText:
                                              'Enter the length of your challenge',
                                          controller: timeframeNumberController,
                                          disabled: !isTimeframe,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ]),
                      ),
                      ReusableCard(
                        child: Column(children: [
                          const Center(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextCustom(text: 'Consequence'),
                            ),
                          ),
                          Wrap(direction: Axis.horizontal, children: [
                            InputCustom(
                              labelText: 'Description',
                              hintText:
                                  'Enter a specific consequence of your challenge',
                              controller: consequenceController,
                              isTall: true,
                            ),
                          ]),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
