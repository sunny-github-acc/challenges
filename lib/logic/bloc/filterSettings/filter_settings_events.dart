import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class FilterSettingsEvent {
  const FilterSettingsEvent();
}

@immutable
class FilterSettingsEventGetFilterSettings implements FilterSettingsEvent {
  const FilterSettingsEventGetFilterSettings();
}

@immutable
class FilterSettingsEventResetState implements FilterSettingsEvent {
  const FilterSettingsEventResetState();
}

@immutable
class FilterSettingsEventUpdateFilterSettings implements FilterSettingsEvent {
  final String key;
  final String? superKey;
  final dynamic value;

  const FilterSettingsEventUpdateFilterSettings({
    required this.key,
    required this.value,
    this.superKey,
  });
}
