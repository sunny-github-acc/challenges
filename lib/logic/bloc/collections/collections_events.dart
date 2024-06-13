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
