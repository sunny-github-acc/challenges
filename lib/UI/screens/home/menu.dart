import 'package:challenges/components/app_bar.dart';
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

                  return CustomColumn(
                    children: [
                      const CustomText(
                        text: 'Customize your settings',
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        child: null,
                      ),
                      CustomRow(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: SpacingType.small,
                        children: [
                          SwitchCustom(
                            value: state.filterSettings['isPrivate'],
                            onChanged: !isUpdating
                                ? (value) => toggleSwitch('isPrivate', value)
                                : null,
                          ),
                          const CustomText(
                            text: 'Show Personal Challenges Only',
                          ),
                        ],
                      ),
                      CustomRow(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: SpacingType.small,
                        children: [
                          SwitchCustom(
                            value: state.filterSettings['isIncludeFinished'],
                            onChanged: !isUpdating
                                ? (value) => toggleSwitch(
                                      'isIncludeFinished',
                                      value,
                                    )
                                : null,
                          ),
                          const CustomText(
                            text: 'Include Finished Challenges',
                          ),
                        ],
                      ),
                      CustomRow(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: SpacingType.small,
                        children: [
                          SwitchCustom(
                            value: state.filterSettings['isFinished'] == true,
                            onChanged: !isUpdating
                                ? (value) => toggleSwitch(
                                      'isFinished',
                                      value,
                                    )
                                : null,
                          ),
                          const CustomText(
                            text: 'Show Only Finished Challenges',
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 2,
                        ),
                        child: null,
                      ),
                      const CustomDivider(),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        child: null,
                      ),
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
