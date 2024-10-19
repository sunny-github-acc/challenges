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
    on<FilterSettingsEventResetState>((event, emit) async {
      emit(
        const FilterSettingsStateEmpty(),
      );
    });

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

          Map<String, dynamic> updatedFilterSettings = {
            if (key == 'isFinished' && value == true) 'isIncludeFinished': true,
            if (key == 'isIncludeFinished' && value == false)
              'isFinished': false,
            if (key == 'visibility') 'visibility.${event.superKey}': value,
            if (key == 'duration' ||
                key == 'isIncludeFinished' ||
                key == 'isFinished')
              key: value,
          };

          await cloud.updateDocument(
            'users',
            updatedFilterSettings,
            state.filterSettings['uid'],
          );

          Map<String, dynamic> finalFilterSettings = await cloud.getDocument(
            'users',
            state.filterSettings['uid'],
          );

          emit(
            FilterSettingsStateLoad(
              filterSettings: finalFilterSettings,
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
