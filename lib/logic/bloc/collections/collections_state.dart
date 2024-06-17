import 'package:challenges/logic/bloc/collections/collections_error.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class CollectionsState {
  final bool isLoading;
  final CollectionsError? collectionsError;

  const CollectionsState({
    required this.isLoading,
    this.collectionsError,
  });
}

@immutable
class CollectionsStateInitial extends CollectionsState {
  const CollectionsStateInitial()
      : super(
          isLoading: false,
        );

  @override
  String toString() => '🚀 CollectionsStateInitial';
}

@immutable
class CollectionsStateAdding extends CollectionsState {
  const CollectionsStateAdding()
      : super(
          isLoading: true,
        );

  @override
  String toString() => '🚀 CollectionsStateAdding';
}

@immutable
class CollectionsStateAdded extends CollectionsState {
  const CollectionsStateAdded()
      : super(
          isLoading: false,
        );

  @override
  String toString() => '🚀 CollectionsStateAdded';
}

@immutable
class CollectionsStateAddingError extends CollectionsState {
  const CollectionsStateAddingError({
    required CollectionsError collectionsError,
  }) : super(
          isLoading: false,
          collectionsError: collectionsError,
        );

  @override
  String toString() =>
      '🚀 CollectionsStateAddingError(collectionsError: $collectionsError)';
}

@immutable
class CollectionsStateGetting extends CollectionsState {
  const CollectionsStateGetting()
      : super(
          isLoading: true,
        );

  @override
  String toString() => '🚀 CollectionsStateGetting';
}

@immutable
class CollectionsStateGot extends CollectionsState {
  final List<Map<String, dynamic>> collectionsData;

  const CollectionsStateGot({
    required this.collectionsData,
  }) : super(
          isLoading: false,
        );

  @override
  String toString() =>
      '🚀 CollectionsStateGot: (collectionsData: $collectionsData)';
}

@immutable
class CollectionsStateGettingError extends CollectionsState {
  const CollectionsStateGettingError({
    required CollectionsError collectionsError,
  }) : super(
          isLoading: false,
          collectionsError: collectionsError,
        );

  @override
  String toString() =>
      '🚀 CollectionsStateGettingError(collectionsError: $collectionsError)';
}

extension GetCollectionsData on CollectionsState {
  List<Map<String, dynamic>> get collectionsData {
    final cls = this;
    if (cls is CollectionsStateGot) {
      return cls.collectionsData;
    } else {
      return [];
    }
  }
}
