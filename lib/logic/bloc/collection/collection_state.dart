import 'package:challenges/logic/bloc/collection/collection_error.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class CollectionState {
  final bool isLoading;
  final String? success;
  final CollectionError? error;

  const CollectionState({
    required this.isLoading,
    this.success,
    this.error,
  });
}

@immutable
class CollectionStateEmpty extends CollectionState {
  const CollectionStateEmpty()
      : super(
          isLoading: false,
        );

  @override
  String toString() => '🚀 CollectionStateEmpty';
}

@immutable
class CollectionStateSet extends CollectionState {
  final Map<String, dynamic> collection;
  final bool isOwner;

  const CollectionStateSet({
    required this.collection,
    required this.isOwner,
    isLoading,
    success,
    error,
  }) : super(
          isLoading: isLoading ?? false,
          success: success,
          error: error,
        );

  @override
  String toString() =>
      '🚀 CollectionStateSet: (collection: $collection, isOwner: $isOwner, isLoading: $isLoading, success: $success, error: $error)';
}

extension GetCollection on CollectionState {
  Map<String, dynamic> get collection {
    final cls = this;
    if (cls is CollectionStateSet) {
      return cls.collection;
    } else {
      return {};
    }
  }
}

extension GetIsOwner on CollectionState {
  bool get isOwner {
    final cls = this;
    if (cls is CollectionStateSet) {
      return cls.isOwner;
    } else {
      return false;
    }
  }
}

extension GetError on CollectionState {
  String? get error {
    final cls = this;
    if (cls is CollectionStateSet) {
      return cls.error.toString();
    } else {
      return null;
    }
  }
}
