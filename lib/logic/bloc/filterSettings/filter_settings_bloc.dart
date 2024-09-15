import 'package:bloc/bloc.dart';
import 'package:challenges/logic/bloc/filterSettings/filter_settings_error.dart';
import 'package:challenges/logic/bloc/filterSettings/filter_settings_events.dart';
import 'package:challenges/logic/bloc/filterSettings/filter_settings_state.dart';
import 'package:challenges/services/auth/auth.dart';
import 'package:challenges/services/cloud/cloud.dart';
import 'package:flutter/foundation.dart';

class FilterSettingsBloc
    extends Bloc<FilterSettingsEvent, FilterSettingsState> {
  FilterSettingsBloc()
      : super(
          const FilterSettingsStateEmpty(),
        ) {
    on<FilterSettingsEventGetFilterSettings>(
      (event, emit) async {
        emit(
          FilterSettingsStateLoad(
            filterSettings: state.filterSettings,
            isLoading: true,
          ),
        );

        try {
          CloudService cloud = CloudService();
          final user = AuthService().getUser();
          final data = await cloud.getDocument('users', user['uid']);

          emit(
            FilterSettingsStateLoad(
              filterSettings: data,
            ),
          );
        } catch (e) {
          if (kDebugMode) {
            print('FilterSettingsEventLogIn error 🚀');
            print(e);
          }

          emit(
            FilterSettingsStateLoad(
              filterSettings: state.filterSettings,
              error: FilterSettingsError.from(e),
            ),
          );
        }
      },
    );

    on<FilterSettingsEventUpdateFilterSettings>(
      (event, emit) async {
        final key = event.key;
        final value = event.value;

        emit(
          FilterSettingsStateLoad(
            key: key,
            filterSettings: state.filterSettings,
            isLoading: true,
          ),
        );

        try {
          CloudService cloud = CloudService();

          final user = AuthService().getUser();
          final data = await cloud.getDocument('users', user['uid']);

          Map<String, dynamic> updatedFilterSettings = data
            ..addAll({
              key: value,
              if (key == 'isIncludeFinished' && value == false)
                'isFinished': false,
              if (key == 'isFinished' && value == true)
                'isIncludeFinished': true,
            });

          await cloud.setCollection(
            'users',
            updatedFilterSettings,
            customDocumentId: updatedFilterSettings['uid'],
          );

          emit(
            FilterSettingsStateLoad(
              filterSettings: updatedFilterSettings,
              success: 'Filter settings updated successfully 🎉',
            ),
          );
        } catch (e) {
          if (kDebugMode) {
            print('FilterSettingsEventLogIn error 🚀');
            print(e);
          }

          emit(
            FilterSettingsStateLoad(
              filterSettings: state.filterSettings,
              error: FilterSettingsError.from(e),
            ),
          );
        }
      },
    );
  }
}
