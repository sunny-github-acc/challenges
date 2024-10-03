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

                  List<dynamic> sortedFilterSettings =
                      state.filterSettings['visibility'].entries.map((entry) {
                    if (entry.key == 'public') {
                      return MapEntry(
                        'Public challenges',
                        entry.value,
                      );
                    } else {
                      return MapEntry(
                        entry.key,
                        entry.value,
                      );
                    }
                  }).toList()
                        ..sort((a, b) {
                          if (a.key == 'Public challenges') {
                            return -1;
                          }
                          return 1;
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
                                (entry) => entry.key != 'private'
                                    ? CustomCheckbox(
                                        isChecked: entry.value,
                                        label: entry.key,
                                        onChanged: (updatedValue) {
                                          handleVisibility(
                                            entry.key == 'Public challenges'
                                                ? 'public'
                                                : entry.key,
                                            !entry.value,
                                          );
                                        },
                                      )
                                    : const SizedBox(),
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
                              'Week',
                              'Month',
                              'Year',
                              'Infinite',
                              'All',
                            ],
                            hint: 'Select an option',
                            value: state.filterSettings['duration'],
                            onChanged: (dynamic value) {
                              if (!isDuration) {
                                handleDuration(value as String);
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
