import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/checkbox.dart';
import 'package:challenges/components/circular_progress_indicator.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/divider.dart';
import 'package:challenges/components/dropdown.dart';
import 'package:challenges/components/row.dart';
import 'package:challenges/components/switch.dart';
import 'package:challenges/components/text.dart';
import 'package:challenges/logic/bloc/filterSettings/filter_settings_bloc.dart';
import 'package:challenges/logic/bloc/filterSettings/filter_settings_events.dart';
import 'package:challenges/logic/bloc/filterSettings/filter_settings_state.dart';
import 'package:challenges/services/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _Menu();
}

class _Menu extends State<Menu> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FilterSettingsBloc>(context).add(
      const FilterSettingsEventGetFilterSettings(),
    );
  }

  final internalToDisplay = {
    'Week': 'One Week',
    'Month': 'One Month',
    'Year': 'One Year',
    'Infinite': 'No Limit',
    'All': 'All',
  };

  final displayToInternal = {
    'One Week': 'Week',
    'One Month': 'Month',
    'One Year': 'Year',
    'No Limit': 'Infinite',
    'All': 'All',
  };

  void getFilterSettings(context) async {
    FilterSettingsBloc bloc = BlocProvider.of<FilterSettingsBloc>(context);

    if (bloc.state is! FilterSettingsStateLoad) {
      bloc.add(const FilterSettingsEventGetFilterSettings());
    }
  }

  void toggleSwitch(String key, bool value) {
    BlocProvider.of<FilterSettingsBloc>(context).add(
      FilterSettingsEventUpdateFilterSettings(
        key: key,
        value: value,
      ),
    );
  }

  void handleVisibility(String key, bool value) {
    BlocProvider.of<FilterSettingsBloc>(context).add(
      FilterSettingsEventUpdateFilterSettings(
        key: 'visibility',
        superKey: key,
        value: value,
      ),
    );
  }

  void handleDuration(String value) {
    BlocProvider.of<FilterSettingsBloc>(context).add(
      FilterSettingsEventUpdateFilterSettings(
        key: 'duration',
        value: value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Filter Settings',
      ),
      body: SingleChildScrollView(
        child: CustomContainer(
          paddingHorizontal: 12,
          paddingVertical: 16,
          child: CustomColumn(
            children: [
              BlocBuilder<FilterSettingsBloc, FilterSettingsState>(
                builder: (context, state) {
                  if ((state is FilterSettingsStateEmpty || state.isLoading) &&
                      state.filterSettings.isEmpty) {
                    return const CustomCircularProgressIndicator();
                  }

                  if (state.error != null) {
                    return CustomColumn(
                      children: [
                        CustomText(
                          text: state.error!.dialogText,
                        ),
                        ElevatedButton(
                          onPressed: () => getFilterSettings(context),
                          child: const CustomText(text: 'Refresh'),
                        ),
                      ],
                    );
                  }

                  bool isUpdating = state.isLoading;
                  bool isDuration = isUpdating && state.key == 'duration';

                  Map<String, Object?> user = AuthService().getUser();
                  List<dynamic> sortedFilterSettings =
                      state.filterSettings['visibility'].entries.map((entry) {
                    if (entry.key == 'public') {
                      return MapEntry('Public challenges', entry.value);
                    } else if (entry.key == user['uid']) {
                      return MapEntry('Private challenges', entry.value);
                    } else {
                      return MapEntry(entry.key, entry.value);
                    }
                  }).toList();

                  const List<String> prioritizedOrder = [
                    'Private challenges',
                    'Public challenges',
                  ];

                  sortedFilterSettings.sort((a, b) {
                    String keyA = a.key;
                    String keyB = b.key;

                    int indexA = prioritizedOrder.indexOf(keyA);
                    int indexB = prioritizedOrder.indexOf(keyB);

                    // Case 1: Both keys are in the prioritized list
                    if (indexA != -1 && indexB != -1) {
                      return indexA.compareTo(indexB);
                    }
                    // Case 2: Only keyA is in the prioritized list (so it comes first)
                    else if (indexA != -1) {
                      return -1;
                    }
                    // Case 3: Only keyB is in the prioritized list (so it comes first)
                    else if (indexB != -1) {
                      return 1;
                    }
                    // Case 4: Neither key is in the prioritized list, sort them alphabetically (or by another logic)
                    else {
                      return keyA.compareTo(keyB);
                    }
                  });

                  return CustomColumn(
                    spacing: SpacingType.small,
                    children: [
                      const CustomText(
                        text: 'Customize your settings',
                        fontSize: FontSizeType.large,
                      ),
                      const CustomDivider(),
                      const CustomText(
                        text: 'What challenges do you want to see?',
                      ),
                      if (state.filterSettings['visibility'] != null)
                        CustomColumn(
                          children: sortedFilterSettings
                              .map<Widget>(
                                (entry) => CustomCheckbox(
                                  isChecked: entry.value,
                                  label: entry.key,
                                  onChanged: (updatedValue) {
                                    handleVisibility(
                                      entry.key == 'Public challenges'
                                          ? 'public'
                                          : entry.key == 'Private challenges'
                                              ? user['uid']
                                              : entry.key,
                                      !entry.value,
                                    );
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      const CustomDivider(),
                      CustomRow(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: SpacingType.small,
                        children: [
                          CustomSwitch(
                            value: state.filterSettings['isIncludeFinished'],
                            onChanged: !isUpdating
                                ? (value) => toggleSwitch(
                                      'isIncludeFinished',
                                      value,
                                    )
                                : null,
                          ),
                          const CustomText(
                            text: 'Include finished challenges',
                          ),
                        ],
                      ),
                      CustomRow(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: SpacingType.small,
                        children: [
                          CustomSwitch(
                            value: state.filterSettings['isFinished'] == true,
                            onChanged: !isUpdating
                                ? (value) => toggleSwitch(
                                      'isFinished',
                                      value,
                                    )
                                : null,
                          ),
                          const CustomText(
                            text: 'Show only finished challenges',
                          ),
                        ],
                      ),
                      const CustomDivider(),
                      CustomColumn(
                        children: [
                          const CustomText(
                            text: 'The duration of the challenges',
                          ),
                          CustomDropdown(
                            values: const [
                              'One Week',
                              'One Month',
                              'One Year',
                              'No Limit',
                              'All',
                            ],
                            hint: 'Select an option',
                            value: internalToDisplay[
                                state.filterSettings['duration']],
                            onChanged: (dynamic value) {
                              final updatedValue = displayToInternal[value];
                              if (!isDuration) {
                                handleDuration(updatedValue as String);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
