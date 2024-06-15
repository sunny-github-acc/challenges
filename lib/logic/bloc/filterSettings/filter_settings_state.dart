import 'package:challenges/logic/bloc/filterSettings/filter_settings_error.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class FilterSettingsState {
  final bool isLoading;
  final FilterSettingsError? filterSettingsError;

  const FilterSettingsState({
    required this.isLoading,
    this.filterSettingsError,
  });
}

@immutable
class FilterSettingsStateEmpty extends FilterSettingsState {
  const FilterSettingsStateEmpty()
      : super(
          isLoading: false,
        );

  @override
  String toString() => '🚀 FilterSettingsStateEmpty';
}

@immutable
class FilterSettingsStateLoadingGet extends FilterSettingsState {
  const FilterSettingsStateLoadingGet()
      : super(
          isLoading: true,
        );

  @override
  String toString() => '🚀 FilterSettingsStateLoadingGet';
}

@immutable
class FilterSettingsStateLoadingUpdate extends FilterSettingsState {
  final Map<String, dynamic> filterSettings;
  final String key;

  const FilterSettingsStateLoadingUpdate({
    required this.filterSettings,
    required this.key,
  }) : super(
          isLoading: true,
        );

  @override
  String toString() =>
      '🚀 FilterSettingsStateLoadingUpdate: (filterSettings: $filterSettings, key: $key)';
}

@immutable
class FilterSettingsStateLoaded extends FilterSettingsState {
  final Map<String, dynamic> filterSettings;

  const FilterSettingsStateLoaded({
    required this.filterSettings,
  }) : super(
          isLoading: false,
        );

  @override
  String toString() =>
      '🚀 FilterSettingsStateLoaded(filterSettings: $filterSettings)';
}

@immutable
class FilterSettingsStateError extends FilterSettingsState {
  const FilterSettingsStateError({
    required FilterSettingsError filterSettingsError,
  }) : super(
          isLoading: false,
          filterSettingsError: filterSettingsError,
        );

  @override
  String toString() =>
      '🚀 FilterSettingsStateLoaded(filterSettings: $filterSettingsError)';
}

extension GetFilterSettings on FilterSettingsState {
  Map<String, dynamic>? get filterSettings {
    final cls = this;
    if (cls is FilterSettingsStateLoaded) {
      return cls.filterSettings;
    } else if (cls is FilterSettingsStateLoadingUpdate) {
      return cls.filterSettings;
    } else {
      return null;
    }
  }
}
