import 'package:challenges/logic/bloc/collections/collections_error.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class CollectionsState {
  final bool isLoading;
  final String? success;
  final CollectionsError? error;

  const CollectionsState({
    required this.isLoading,
    this.success,
    this.error,
  });
}

@immutable
class CollectionsStateEmpty extends CollectionsState {
  const CollectionsStateEmpty()
      : super(
          isLoading: false,
        );

  @override
  String toString() => '🚀 CollectionsStateEmpty';
}

@immutable
class CollectionsStateUpdated extends CollectionsState {
  final List<Map<String, dynamic>> collections;

  const CollectionsStateUpdated({
    required this.collections,
    success,
    isLoading,
    error,
  }) : super(
          isLoading: isLoading ?? false,
          success: success,
          error: error,
        );

  @override
  String toString() =>
      '🚀 CollectionsStateAdded(collections: $collections, isLoading: $isLoading, success: $success, error: $error)';
}

extension GetCollections on CollectionsState {
  List<Map<String, dynamic>> get collections {
    final cls = this;
    if (cls is CollectionsStateUpdated) {
      return cls.collections;
    } else {
      return [];
    }
  }
}
