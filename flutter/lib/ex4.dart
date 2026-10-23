Future<String> uploadPhoto(String name) async {
  await Future<void>.delayed(const Duration(milliseconds: 100));
  if (name.endsWith('.heic')) throw FormatException('unsupported: $name');
  return 'uploaded $name';
}

Future<String> uploadWithRetry(String name, int attempts) async {
  if (attempts < 1) {
    throw RangeError('attempts must be a positive integer');
  }

  var delay = 400;
  for (var attempt = 1; attempt <= attempts; attempt++) {
    try {
      return await uploadPhoto(name);
    } catch (_) {
      if (attempt == attempts) rethrow;
      await Future<void>.delayed(Duration(milliseconds: delay));
      delay *= 2;
    }
  }

  throw StateError('Upload retry loop ended unexpectedly');
}

Future<String> settle(Future<String> f) async {
  try {
    return await f;
  } on FormatException catch (e) {
    return 'failed: ${e.message}';
  }
}

Future<void> main() async {
  final names = ['a.jpg', 'b.heic', 'c.jpg'];
  final results = await Future.wait(names.map((n) => settle(uploadWithRetry(n, 3))));
  for (final r in results) {
    print(r);
  }

  try {
    await uploadPhoto('d.heic');
  } on FormatException catch (e) {
    print('caught ${e.message}');
  }
}