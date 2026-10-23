abstract interface class HasId {
  String get id;
}

class MemoryRepo<T extends HasId> {
  final _items = <String, T>{};
  void save(T item) => _items[item.id] = item;
  T? find(String id) => _items[id];
  int count() => _items.length;
  bool remove(String id) => _items.remove(id) != null;
  List<T> where(bool Function(T) test) => _items.values.where(test).toList();
}

class Pin implements HasId {
  @override
  final String id;
  final int floors;
  final bool hasShops;
  const Pin(this.id, this.floors, {this.hasShops = false});
}

void main() {
  final repo = MemoryRepo<Pin>()
    ..save(const Pin('b-1', 4, hasShops: true))
    ..save(const Pin('b-2', 11))
    ..save(const Pin('b-3', 8, hasShops: true));
  final tall = repo.where((p) => p.floors > 5).map((p) => p.id);
  final totalFloors = repo.where((_) => true).fold(0, (sum, p) => sum + p.floors);
  final shopPins = repo.where((p) => p.hasShops)
    ..sort((a, b) => b.floors.compareTo(a.floors));
  print('${tall.join(',')} $totalFloors ${repo.find('b-9')?.floors ?? 'none'}');
  print(shopPins.map((p) => p.id).join(','));
}