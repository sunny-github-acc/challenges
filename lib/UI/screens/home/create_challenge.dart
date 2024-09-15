import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/circular_progress_indicator.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/date.dart';
import 'package:challenges/components/dropdown.dart';
import 'package:challenges/components/input.dart';
import 'package:challenges/components/modal.dart';
import 'package:challenges/components/text.dart';
import 'package:challenges/logic/bloc/collections/collections_bloc.dart';
import 'package:challenges/logic/bloc/collections/collections_events.dart';
import 'package:challenges/logic/bloc/collections/collections_state.dart';
import 'package:challenges/services/auth/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  // String visibility = 'Public';
  bool isPrivate = false;
  bool isTitle = true;
  bool isDuration = true;
  DateTime today = DateTime.now();
  DateTime customStartDate = DateTime.now();
  DateTime customEndDate = DateTime.now().add(const Duration(days: 7));

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
      'duration': duration,
      'consequence': consequence,
      'isPrivate': isPrivate,
      'isFinished': false,
    };

    setState(() {
      isTitle = title.isNotEmpty;
    });

    if (!isTitle || !isDuration) {
      return Modal.show(context, 'Oops', 'Please fill out all input fields');
    }

    BlocProvider.of<CollectionsBloc>(context).add(CollectionsEventAddCollection(
      title: 'challenges',
      document: document,
    ));
  }

  void _handleDuration(BuildContext context, String durationParam) {
    setState(() {
      duration = durationParam;
    });
  }

  void _handleIsPrivate(BuildContext context, bool isPrivateParam) {
    setState(() {
      isPrivate = isPrivateParam;
    });
  }

  DateTime _getEndDate(duration, customDate) {
    if (duration == 'Custom') {
      return customDate;
    } else {
      return DateTime.utc(
        today.year + (duration == 'Year' ? 1 : 0),
        today.month + (duration == 'Month' ? 1 : 0),
        today.day + (duration == 'Week' || duration == 'Infinite' ? 7 : 0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CollectionsBloc, CollectionsState>(
      listener: (context, state) {
        if (kDebugMode) {
          print('🚀 BlocListener CollectionsBloc state: $state');
        }

        if (state.success != null) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: CustomText(text: state.success!),
                duration: const Duration(seconds: 2)),
          );

          Navigator.pop(context);
        }

        if (state.error != null) {
          Modal.show(
            context,
            state.error!.dialogTitle,
            state.error!.dialogText,
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Create Challenge',
          leftButton: BlocBuilder<CollectionsBloc, CollectionsState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const CustomCircularProgressIndicator();
              }

              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              );
            },
          ),
          actions: [
            BlocBuilder<CollectionsBloc, CollectionsState>(
              builder: (context, state) {
                return CustomButton(
                  text: 'Save',
                  size: ButtonSize.small,
                  isLoading: state.isLoading,
                  onPressed: () => _save(context),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: CustomContainer(
            child: CustomColumn(
              spacing: SpacingType.medium,
              children: [
                CustomInput(
                  title: 'Enter a title',
                  labelText: 'Make it short and sweet',
                  controller: titleController,
                  isDisabled: !isTitle,
                ),
                CustomInput(
                  title: 'Describe your challenge',
                  labelText: 'Be as specific as you can',
                  controller: descriptionController,
                  isTall: true,
                ),
                CustomInput(
                  title: 'Enter a consequence',
                  labelText:
                      'What will happen if your challenge succeeds or fails?',
                  controller: consequenceController,
                  isTall: true,
                ),
                CustomColumn(
                  spacing: SpacingType.small,
                  children: [
                    const CustomText(
                      text: 'How long will your challenge last?',
                    ),
                    CustomDropdown(
                      values: const [
                        'Week',
                        'Month',
                        'Year',
                        'Infinite',
                        'Custom',
                      ],
                      hint: 'Select an option',
                      value: duration,
                      onChanged: (dynamic value) {
                        _handleDuration(context, value as String);
                      },
                    ),
                    if (duration == 'Custom')
                      CustomDateRangePicker(
                        dateRange: DateTimeRange(
                          start: customStartDate,
                          end: customEndDate,
                        ),
                        onSelected: (date) {
                          setState(() {
                            customStartDate = date.start;
                            customEndDate = date.end;
                          });
                        },
                      ),
                  ],
                ),
                CustomColumn(
                  spacing: SpacingType.small,
                  children: [
                    const CustomText(
                      text: 'Who can see your challenge?',
                    ),
                    CustomDropdown(
                      titles: const [
                        'Everyone',
                        'Only me',
                      ],
                      values: const [
                        false,
                        true,
                      ],
                      hint: 'Select an option',
                      value: isPrivate,
                      onChanged: (dynamic value) {
                        _handleIsPrivate(context, value as bool);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
