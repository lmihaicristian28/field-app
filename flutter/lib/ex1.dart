class Building {
  final String id;
  final String address;
  final int? floors; // null = not surveyed yet
  final int? elevators;
  const Building({required this.id, required this.address, this.floors, this.elevators});

  Building copyWith({int? floors, int? elevators}) =>
      Building(id: id, address: address, floors: floors ?? this.floors, elevators: elevators ?? this.elevators);
}

String describe(Building b) {
  final floors = b.floors ?? 'unknown';
  final elevators = b.elevators ?? 'unknown';
  return '${b.address}: $floors floors, $elevators elevators';
}

const b = Building(id: 'b-17', address: 'Str. Lipscani 12');

void main() {
  var count = 3; // inferred: int
//   count = 'three'; // error: A value of type 'String' can't be assigned to a variable of type 'int'.
  print(describe(b));
  print(describe(b.copyWith(floors: 4)));
  print(b.floors?.toStringAsFixed(1) ?? 'n/a');
  print('count is $count');
}