import 'package:challenges/logic/bloc/filterSettings/filter_settings_error.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class FilterSettingsState {
  final bool isLoading;
  final String? success;
  final FilterSettingsError? error;

  const FilterSettingsState({
    required this.isLoading,
    this.success,
    this.error,
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
class FilterSettingsStateLoad extends FilterSettingsState {
  final Map<String, dynamic> filterSettings;
  final String? key;

  const FilterSettingsStateLoad({
    required this.filterSettings,
    this.key,
    final String? success,
    final FilterSettingsError? error,
    final bool? isLoading,
  }) : super(
          isLoading: isLoading ?? false,
        );

  @override
  String toString() =>
      '🚀 FilterSettingsStateLoad: (filterSettings: $filterSettings, key: $key, success: $success, error: $error)';
}

extension GetFilterSettings on FilterSettingsState {
  Map<String, dynamic> get filterSettings {
    final cls = this;
    if (cls is FilterSettingsStateLoad) {
      return cls.filterSettings;
    } else {
      return {};
    }
  }
}

extension GetFilterSettingsKey on FilterSettingsState {
  String get key {
    final cls = this;
    if (cls is FilterSettingsStateLoad) {
      return cls.key ?? '';
    } else {
      return '';
    }
  }
}
