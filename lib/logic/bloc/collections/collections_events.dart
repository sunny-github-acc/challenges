import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class CollectionsEvent {
  const CollectionsEvent();
}

@immutable
class CollectionsEventAddCollection implements CollectionsEvent {
  final String title;
  final Map<String, dynamic> document;

  const CollectionsEventAddCollection({
    required this.title,
    required this.document,
  });
}

@immutable
class CollectionsEventGetCollection implements CollectionsEvent {
  final Map<String, dynamic> query;

  const CollectionsEventGetCollection({
    required this.query,
  });
}

@immutable
class CollectionsEventInitiateStream implements CollectionsEvent {
  final Map<String, dynamic> query;

  const CollectionsEventInitiateStream({
    required this.query,
  });
}

@immutable
class CollectionsEventStream implements CollectionsEvent {
  final List<Map<String, dynamic>> sortedData;

  const CollectionsEventStream({
    required this.sortedData,
  });
}
