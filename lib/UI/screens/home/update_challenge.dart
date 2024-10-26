import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/circular_progress_indicator.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/date.dart';
import 'package:challenges/components/divider.dart';
import 'package:challenges/components/dropdown.dart';
import 'package:challenges/components/editable_text.dart';
import 'package:challenges/components/modal.dart';
import 'package:challenges/components/row.dart';
import 'package:challenges/components/switch.dart';
import 'package:challenges/components/text.dart';
import 'package:challenges/logic/bloc/auth/auth_bloc.dart';
import 'package:challenges/logic/bloc/auth/auth_state.dart';
import 'package:challenges/logic/bloc/collection/collection_bloc.dart';
import 'package:challenges/logic/bloc/collection/collection_events.dart';
import 'package:challenges/logic/bloc/collection/collection_state.dart';
import 'package:challenges/logic/bloc/tribes/tribes_bloc.dart';
import 'package:challenges/logic/bloc/tribes/tribes_events.dart';
import 'package:challenges/logic/bloc/tribes/tribes_state.dart';
import 'package:challenges/services/auth/auth.dart';
import 'package:challenges/utils/helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Statuses {
  static const String completed = 'Completed 🌟';
  static const String failed = 'Failed 😴';
  static const String inProgress = 'In Progress 🚀';
}

class UpdateChallenge extends StatelessWidget {
  const UpdateChallenge({super.key});

  save(BuildContext context, String type, dynamic input) async {
    Map<String, dynamic> updatedCollection = {
      'createdAt': DateTime.now(),
      type: input,
      if (type == 'duration') 'startDate': DateTime.now(),
      if (type == 'duration')
        'endDate': DateTime.now().add(
          const Duration(
            days: 7,
          ),
        ),
    };

    BlocProvider.of<CollectionBloc>(context).add(
      CollectionEventUpdateCollection(
        collection: updatedCollection,
      ),
    );
  }

  saveDate(BuildContext context, DateTimeRange input) async {
    Map<String, dynamic> updatedCollection = {
      'createdAt': DateTime.now(),
      'startDate': input.start,
      'endDate': input.end,
      'duration': getDuration(input.start, input.end),
    };

    BlocProvider.of<CollectionBloc>(context).add(
      CollectionEventUpdateCollection(
        collection: updatedCollection,
      ),
    );
  }

  setStatus(BuildContext context, String status) {
    bool isFinished = status == Statuses.completed || status == Statuses.failed;
    Map<String, dynamic> updatedCollection = {
      'createdAt': DateTime.now(),
      'isFinished': isFinished,
      if (isFinished) 'isSuccess': status == Statuses.completed,
    };

    BlocProvider.of<CollectionBloc>(context).add(
      CollectionEventUpdateCollection(
        collection: updatedCollection,
      ),
    );
  }

  delete(BuildContext context, String id) async {
    BlocProvider.of<CollectionBloc>(context).add(
      CollectionEventDeleteCollection(
        collectionId: id,
      ),
    );

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    User? user = BlocProvider.of<AuthBloc>(context).state.user;
    TribesState tribesState = BlocProvider.of<TribesBloc>(context).state;

    if (user != null && tribesState is! TribesStateGot) {
      BlocProvider.of<TribesBloc>(context).add(
        TribesEventGetTribes(
          user: user,
        ),
      );
    }

    return GestureDetector(
      onTapDown: (details) {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Update Challenge',
        ),
        body: BlocBuilder<CollectionBloc, CollectionState>(
          builder: (context, state) {
            if (state.success != null) {
              SchedulerBinding.instance.addPostFrameCallback(
                (_) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: CustomText(text: state.success!),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            }

            if (state.collection.isEmpty) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            Map<String, dynamic> collection = state.collection;
            dynamic startDateDynamic = collection['startDate'];
            dynamic endDateDynamic = collection['endDate'];
            dynamic startDate = startDateDynamic is Timestamp
                ? startDateDynamic.toDate()
                : startDateDynamic;
            dynamic endDate = endDateDynamic is Timestamp
                ? endDateDynamic.toDate()
                : endDateDynamic;

            if (state.error != null) {
              SchedulerBinding.instance.addPostFrameCallback(
                (_) {
                  Modal.show(
                    context,
                    state.error!.dialogTitle,
                    state.error!.dialogText,
                  );
                },
              );
            }

            AuthService auth = AuthService();
            Map user = auth.getUser();
            bool isOwner = user['email'] == collection['email'];

            return CustomContainer(
              paddingBottom: 0,
              child: CustomColumn(
                spacing: SpacingType.medium,
                children: [
                  CustomColumn(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      CustomColumn(
                        spacing: SpacingType.medium,
                        children: [
                          CustomTextInput(
                            text: collection['title'],
                            isTitle: true,
                            isTextRequired: true,
                            onSave: (input) => save(context, 'title', input),
                            limit: 50,
                          ),
                          CustomTextInput(
                            text: collection['description'],
                            hint: 'Enter your description here',
                            onSave: (input) => save(
                              context,
                              'description',
                              input,
                            ),
                            limit: 300,
                          ),
                          CustomTextInput(
                            text: collection['consequence'],
                            hint: 'Enter your consequence here',
                            onSave: (input) => save(
                              context,
                              'consequence',
                              input,
                            ),
                            limit: 300,
                          ),
                        ],
                      ),
                      const CustomDivider(),
                    ],
                  ),
                  if (collection['duration'] != 'Infinite')
                    CustomDateRangePicker(
                      dateRange: DateTimeRange(
                        start: startDate,
                        end: endDate,
                      ),
                      onSelected: (date) {
                        saveDate(context, date);
                      },
                    ),
                  CustomRow(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: SpacingType.small,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: CustomSwitch(
                          value: collection['duration'] == 'Infinite',
                          onChanged: (value) => save(
                            context,
                            'duration',
                            value ? 'Infinite' : 'Week',
                          ),
                        ),
                      ),
                      const CustomText(
                        text: 'Infinite duration',
                      ),
                    ],
                  ),
                  const CustomDivider(),
                  CustomColumn(
                    children: [
                      const CustomText(
                        text: 'Who can see your challenge?',
                      ),
                      CustomRow(
                        spacing: SpacingType.medium,
                        children: [
                          BlocBuilder<TribesBloc, TribesState>(
                            builder: (context, state) {
                              if (state.isLoading) {
                                return const CustomCircularProgressIndicator(
                                  scale: 0.5,
                                );
                              }

                              if (state is TribesStateEmpty) {
                                return const CustomText(
                                  text: 'Could not load tribes',
                                );
                              }

                              return CustomDropdown(
                                values: [
                                  'Everyone',
                                  'Only me',
                                  ...state.tribes,
                                ],
                                hint: 'Select an option',
                                value: collection['visibility'] == user['uid']
                                    ? 'Only me'
                                    : collection['visibility'] == 'public'
                                        ? 'Everyone'
                                        : collection['visibility'],
                                onChanged: (dynamic value) {
                                  Map<String, String> visibilityMap = {
                                    'Everyone': 'public',
                                    'Only me': user['uid'],
                                  };

                                  save(
                                    context,
                                    'visibility',
                                    visibilityMap[value] ?? value,
                                  );
                                },
                              );
                            },
                          ),
                          if (collection['visibility'] == user['uid'])
                            CustomButton(
                              size: ButtonSize.small,
                              icon: IconType.info,
                              onPressed: () => {
                                Modal.show(
                                  context,
                                  'Private Challenges',
                                  'Check your profile to see your challenges. Public challenges are displayed on the home screen.',
                                ),
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (isOwner)
                    CustomColumn(
                      children: [
                        const CustomText(
                          text: 'Status',
                        ),
                        CustomDropdown(
                          values: const [
                            Statuses.completed,
                            Statuses.failed,
                            Statuses.inProgress,
                          ],
                          hint: 'Select an option',
                          value: collection['isFinished'] == true
                              ? collection['isSuccess'] == true
                                  ? Statuses.completed
                                  : Statuses.failed
                              : Statuses.inProgress,
                          onChanged: (dynamic value) {
                            setStatus(
                              context,
                              value,
                            );
                          },
                        )
                      ],
                    ),
                  const CustomDivider(),
                  CustomButton(
                    onPressed: () => delete(
                      context,
                      collection['id'],
                    ),
                    text: 'Delete Challenge',
                    type: ButtonType.danger,
                    size: ButtonSize.small,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
