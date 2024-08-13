import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/circular_progress_indicator.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/components/container_gradient.dart';
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
    initValues(context);
  }

  void initValues(context) async {
    FilterSettingsBloc bloc = BlocProvider.of<FilterSettingsBloc>(context);

    if (bloc.state is! FilterSettingsStateLoad) {
      bloc.add(const FilterSettingsEventGetFilterSettings());
    }
  }

  void toggleSwitch(String key, bool value) {
    BlocProvider.of<FilterSettingsBloc>(context)
        .add(FilterSettingsEventUpdateFilterSettings(key: key, value: value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Menu',
      ),
      body: SingleChildScrollView(
        child: ContainerGradient(
          padding: 8,
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
                        TextCustom(
                          text: state.error!.dialogText,
                        ),
                        ElevatedButton(
                          onPressed: () => initValues(context),
                          child: const Text('Refresh'),
                        ),
                      ],
                    );
                  }

                  bool isUpdating = state.isLoading;
                  bool isPrivate = isUpdating && state.key == 'isPrivate';
                  bool isFinished = isUpdating && state.key == 'isFinished';

                  return CustomColumn(
                    children: [
                      CustomRow(
                        children: [
                          const TextCustom(
                              text: 'Only show private challenges'),
                          isPrivate
                              ? const CustomCircularProgressIndicator()
                              : SwitchCustom(
                                  value: state.filterSettings['isPrivate'],
                                  onChanged: isUpdating
                                      ? () => null
                                      : (value) =>
                                          toggleSwitch('isPrivate', value),
                                ),
                        ],
                      ),
                      CustomRow(
                        children: [
                          const TextCustom(
                              text: 'Only show finished challenges'),
                          isFinished
                              ? const CustomCircularProgressIndicator()
                              : SwitchCustom(
                                  value: state.filterSettings['isFinished'],
                                  onChanged: isUpdating
                                      ? () => null
                                      : (value) => toggleSwitch(
                                            'isFinished',
                                            value,
                                          ),
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
