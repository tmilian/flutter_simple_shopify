import 'package:freezed_annotation/freezed_annotation.dart';

import '../collection.dart';

part 'collections.freezed.dart';
part 'collections.g.dart';

@freezed
class Collections with _$Collections {
  factory Collections(
      {required List<Collection> collectionList,
      required bool hasNextPage}) = _Collections;

  factory Collections.fromJson(Map<String, dynamic> json) =>
      _$CollectionsFromJson(json);

  static Collections fromGraphJson(Map<String, dynamic> json) {
    return Collections(
        collectionList: _getCollectionList(json),
        hasNextPage: (json['pageInfo'] ?? const {})['hasNextPage']);
  }

  static List<Collection> _getCollectionList(Map<String, dynamic> json) {
    final edges = (json['edges'] as List?) ?? [];
    return edges
        .map((e) => Collection.fromGraphJson(
              e?['node'] ?? const {},
              cursor: e?['cursor'],
            ))
        .toList();
  }
}
