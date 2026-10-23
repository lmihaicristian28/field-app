import 'dart:convert';

abstract interface class Syncable {
  String get id;
  Map<String, Object?> toJson();
}

mixin Timestamped {
  final DateTime createdAt = DateTime.utc(2026, 10, 6, 15, 30);
  String get stamp => createdAt.toIso8601String();
}

abstract class Entity {
  final String id;
  Entity(this.id);
  String label();
}

class Survey extends Entity with Timestamped implements Syncable {
  final String pinId;
  final List<String> _photos = [];
  Survey(super.id, this.pinId);

  void addPhoto(String path) => _photos.add(path);

  @override
  String label() => 'Survey $id (${_photos.length} photos)';

  @override
  Map<String, Object?> toJson() =>
      {'id': id, 'pinId': pinId, 'photos': [..._photos], 'createdAt': stamp};
}

void main() {
  final s = Survey('s-1', 'b-17')..addPhoto('IMG_0001.jpg');
  print(s.label());
  print(jsonEncode(s.toJson()));
}