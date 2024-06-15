import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/circular_progress_indicator.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/switch.dart';
import 'package:challenges/components/text.dart';
import 'package:challenges/logic/bloc/filterSettings/filter_settings_bloc.dart';
import 'package:challenges/logic/bloc/filterSettings/filter_settings_error.dart';
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

    if (bloc.state is! FilterSettingsStateLoaded) {
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
              const TextCustom(text: 'Filter by:'),
              BlocBuilder<FilterSettingsBloc, FilterSettingsState>(
                builder: (context, state) {
                  if (state is FilterSettingsStateEmpty ||
                      state is FilterSettingsStateLoadingGet) {
                    return const CustomCircularProgressIndicator();
                  }

                  if (state is FilterSettingsError) {
                    return CustomColumn(
                      children: [
                        TextCustom(
                          text: state.filterSettingsError!.dialogText,
                        ),
                        ElevatedButton(
                          onPressed: () => initValues(context),
                          child: const Text('Refresh'),
                        ),
                      ],
                    );
                  }

                  bool isUpdating = state is FilterSettingsStateLoadingUpdate;
                  bool isGlobal = isUpdating && state.key == 'isGlobal';
                  bool isUnlimited = isUpdating && state.key == 'isUnlimited';
                  bool isCompleted = isUpdating && state.key == 'isCompleted';

                  return CustomColumn(
                    children: [
                      const TextCustom(text: 'Global'),
                      isGlobal
                          ? const CustomCircularProgressIndicator()
                          : SwitchCustom(
                              value: state.filterSettings!['isGlobal'],
                              onChanged: state
                                      is FilterSettingsStateLoadingUpdate
                                  ? () => null
                                  : (value) => toggleSwitch('isGlobal', value),
                            ),
                      const TextCustom(text: 'Unlimited'),
                      isUnlimited
                          ? const CustomCircularProgressIndicator()
                          : SwitchCustom(
                              value: state.filterSettings!['isUnlimited'],
                              onChanged:
                                  state is FilterSettingsStateLoadingUpdate
                                      ? () => null
                                      : (value) =>
                                          toggleSwitch('isUnlimited', value),
                            ),
                      const TextCustom(text: 'Completed'),
                      isCompleted
                          ? const CustomCircularProgressIndicator()
                          : SwitchCustom(
                              value: state.filterSettings!['isCompleted'],
                              onChanged:
                                  state is FilterSettingsStateLoadingUpdate
                                      ? () => null
                                      : (value) =>
                                          toggleSwitch('isCompleted', value),
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
