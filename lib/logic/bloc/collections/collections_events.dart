import 'package:challenges/services/cloud/cloud.dart';
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
  final QueryType queryType;

  const CollectionsEventGetCollection({
    required this.query,
    this.queryType = QueryType.filter,
  });
}

@immutable
class CollectionsEventInitiateStream implements CollectionsEvent {
  final Map<String, dynamic> query;
  final QueryType queryType;

  const CollectionsEventInitiateStream({
    required this.query,
    this.queryType = QueryType.filter,
  });
}

@immutable
class CollectionsEventStream implements CollectionsEvent {
  final List<Map<String, dynamic>> sortedData;
  final QueryType queryType;

  const CollectionsEventStream({
    required this.sortedData,
    this.queryType = QueryType.filter,
  });
}

class CollectionsEventCancelStream implements CollectionsEvent {
  const CollectionsEventCancelStream();
}
