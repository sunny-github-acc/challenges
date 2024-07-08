import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class CollectionEvent {
  const CollectionEvent();
}

@immutable
class CollectionEventSetCollection implements CollectionEvent {
  final Map<String, dynamic> collection;

  const CollectionEventSetCollection({
    required this.collection,
  });
}

@immutable
class CollectionEventUpdateCollection implements CollectionEvent {
  final Map<String, dynamic> collection;

  const CollectionEventUpdateCollection({
    required this.collection,
  });
}

@immutable
class CollectionEventDeleteCollection implements CollectionEvent {
  final String collectionId;

  const CollectionEventDeleteCollection({
    required this.collectionId,
  });
}
