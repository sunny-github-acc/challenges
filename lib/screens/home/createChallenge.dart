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
  final TextEditingController durationCustomController =
      TextEditingController();
  final TextEditingController consequenceController = TextEditingController();

  String consequence = '';
  String duration = 'Week';
  String visibility = 'Public';
  bool isTitle = true;
  bool isDuration = true;

  Future<void> _save(context) async {
    AuthService authService = AuthService();

    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
    String durationCustom = durationCustomController.text.trim();
    String consequence = consequenceController.text.trim();

    Map user = authService.getUser();

    Map<String, dynamic> document = {
      ...user,
      'title': title,
      'description': description,
      'durationCustom': durationCustom,
      'duration': duration,
      'consequence': consequence,
      'visibility': visibility
    };

    setState(() {
      isTitle = title.isNotEmpty;
      isDuration = duration != 'Custom' || durationCustom.isNotEmpty;
    });

    if (!isTitle || !isDuration) {
      return Modal.show(context, 'Oops', 'Please fill out all input fields');
    }

    CloudService cloudService = CloudService();
    await cloudService.setCollection(context, 'challenges', document);
  }

  void _handleDuration(BuildContext context, String length) {
    setState(() {
      duration = length;
    });
  }

  void _handleVisibility(BuildContext context, String vis) {
    setState(() {
      visibility = vis;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Add a challenge',
          actions: [
            CustomButton(
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomInput(
                        labelText: 'Title',
                        hintText: 'Enter the title of your challenge',
                        controller: titleController,
                        disabled: !isTitle,
                      ),
                      CustomInput(
                        labelText: 'Description',
                        hintText:
                            'Enter a specific description of your challenge',
                        controller: descriptionController,
                        isTall: true,
                      ),
                      ReusableCard(
                        child: Column(children: [
                          const Center(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextCustom(
                                  text: 'The period of the challenge'),
                            ),
                          ),
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
                                          onPressed: () => _handleDuration(
                                              context, 'Custom'),
                                          text: 'Custom',
                                          size: ButtonSize.small,
                                          type: duration == 'Custom'
                                              ? ButtonType.primary
                                              : ButtonType.secondary),
                                      CustomButton(
                                          onPressed: () => _handleDuration(
                                              context, 'Forever'),
                                          text: 'Forever',
                                          size: ButtonSize.small,
                                          type: duration == 'Forever'
                                              ? ButtonType.primary
                                              : ButtonType.secondary),
                                      duration == 'Custom'
                                          ? Center(
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: CustomInput(
                                                  labelText: 'Add calendar',
                                                  hintText:
                                                      'Enter the length of your challenge',
                                                  controller:
                                                      durationCustomController,
                                                  disabled: !isDuration,
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ))),
                        ]),
                      ),
                      ReusableCard(
                        child: Column(children: [
                          const Center(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextCustom(
                                  text:
                                      'What will happen if the challenge will succeed or fail?'),
                            ),
                          ),
                          Wrap(direction: Axis.horizontal, children: [
                            CustomInput(
                              labelText: 'Description',
                              hintText:
                                  'Enter a specific consequence of your challenge',
                              controller: consequenceController,
                              isTall: true,
                            ),
                          ]),
                        ]),
                      ),
                      ReusableCard(
                          child: Column(
                        children: [
                          const Center(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextCustom(
                                  text: 'Public or private challenge?'),
                            ),
                          ),
                          Row(children: [
                            CustomButton(
                                onPressed: () =>
                                    _handleVisibility(context, 'Public'),
                                text: 'Public',
                                size: ButtonSize.small,
                                type: visibility == 'Public'
                                    ? ButtonType.primary
                                    : ButtonType.secondary),
                            CustomButton(
                                onPressed: () =>
                                    _handleVisibility(context, 'Private'),
                                text: 'Private',
                                size: ButtonSize.small,
                                type: visibility == 'Private'
                                    ? ButtonType.primary
                                    : ButtonType.secondary),
                          ]),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
