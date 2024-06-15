import 'package:flutter/foundation.dart';

const Map<String, FilterSettingsError> filterSettingsErrorMapping = {
  'no-data-found': FilterSettingsErrorNoDataFound(),
};

@immutable
abstract class FilterSettingsError {
  final String dialogTitle;
  final String dialogText;

  const FilterSettingsError({
    required this.dialogTitle,
    required this.dialogText,
  });

  factory FilterSettingsError.from(e) {
    if (kDebugMode) {
      print('FilterSettingsError 🚀');
      print(e);
    }

    return const FilterSettingsErrorUnknown();
  }
}

@immutable
class FilterSettingsErrorUnknown extends FilterSettingsError {
  const FilterSettingsErrorUnknown()
      : super(
          dialogTitle: 'Filter Settings Error',
          dialogText: 'Unknown Filter Settings Error',
        );
}

@immutable
class FilterSettingsErrorNoDataFound extends FilterSettingsError {
  const FilterSettingsErrorNoDataFound()
      : super(
          dialogTitle: 'Filter Settings Error',
          dialogText: 'No Data Found',
        );
}
