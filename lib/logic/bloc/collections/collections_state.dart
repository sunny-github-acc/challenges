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
class CollectionsStateLoading extends CollectionsState {
  const CollectionsStateLoading()
      : super(
          isLoading: true,
        );

  @override
  String toString() => '🚀 CollectionsStateLoading';
}

@immutable
class CollectionsStateLoaded extends CollectionsState {
  const CollectionsStateLoaded({
    CollectionsError? collectionsError,
  }) : super(
          isLoading: false,
          collectionsError: collectionsError,
        );

  @override
  String toString() =>
      '🚀 CollectionsStateLoaded(collectionsError: $collectionsError)';
}

@immutable
class CollectionsStateCollectionCollected extends CollectionsState {
  const CollectionsStateCollectionCollected()
      : super(
          isLoading: false,
        );

  @override
  String toString() => '🚀 CollectionsStateCollectionCollected';
}
