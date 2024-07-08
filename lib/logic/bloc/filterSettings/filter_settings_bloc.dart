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
          const FilterSettingsStateLoadingGet(),
        );

        try {
          CloudService cloud = CloudService();
          final user = AuthService().getUser();
          final data = await cloud.getDocument('users', user['uid']);

          emit(
            FilterSettingsStateLoaded(filterSettings: data),
          );
        } catch (e) {
          if (kDebugMode) {
            print('FilterSettingsEventLogIn error 🚀');
            print(e);
          }

          emit(
            FilterSettingsStateError(
              filterSettingsError: FilterSettingsError.from(e),
            ),
          );
        }
      },
    );

    on<FilterSettingsEventUpdateFilterSettings>(
      (event, emit) async {
        final key = event.key;
        final value = event.value;
        final oldFilterSettings = state.filterSettings!;

        emit(
          FilterSettingsStateLoadingUpdate(
              key: key, filterSettings: oldFilterSettings),
        );

        try {
          CloudService cloud = CloudService();

          final user = AuthService().getUser();
          final data = await cloud.getDocument('users', user['uid']);

          Map<String, dynamic> updatedFilterSettings = data
            ..addAll({
              key: value,
            });

          await cloud.setCollection(
            'users',
            updatedFilterSettings,
            customDocumentId: updatedFilterSettings['uid'],
          );

          emit(
            FilterSettingsStateLoaded(filterSettings: updatedFilterSettings),
          );
        } catch (e) {
          if (kDebugMode) {
            print('FilterSettingsEventLogIn error 🚀');
            print(e);
          }

          emit(
            FilterSettingsStateError(
              filterSettingsError: FilterSettingsError.from(e),
            ),
          );
        }
      },
    );
  }
}
