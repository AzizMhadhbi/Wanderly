import 'package:flutter_test/flutter_test.dart';
import 'package:wanderly/models/category.dart';
import 'package:wanderly/models/destination.dart';
import 'package:wanderly/repositories/destination_repository.dart';

Destination customDestination(String id, String name, String country) =>
    Destination(
      id: id,
      name: name,
      country: country,
      category: Category.beach,
      description: 'Test destination',
      imagePath: 'assets/images/beach.jpg',
      latitude: 0,
      longitude: 0,
    );

void main() {
  late DestinationRepository repository;

  setUp(() => repository = DestinationRepository(seed: <Destination>[]));

  group('DestinationRepository', () {
    test('add appends and exposes an immutable snapshot', () {
      repository.add(customDestination('1', 'Bali', 'Indonesia'));
      expect(repository.all, hasLength(1));
      expect(() => repository.all.add(customDestination('2', 'X', 'Y')),
          throwsUnsupportedError);
    });

    test('toggleFavourite flips state and favourites filters correctly', () {
      repository.add(customDestination('1', 'Bali', 'Indonesia'));
      repository.toggleFavourite('1');
      expect(repository.favourites, hasLength(1));
      repository.toggleFavourite('1');
      expect(repository.favourites, isEmpty);
    });

    test('update replaces an existing item and ignores unknown ids', () {
      final item = customDestination('1', 'Bali', 'Indonesia');
      repository.add(item);
      repository.update(item.copyWith(name: 'Bali Updated'));
      expect(repository.all.single.name, 'Bali Updated');

      repository.update(customDestination('missing', 'X', 'Y'));
      expect(repository.all, hasLength(1));
    });

    test('remove deletes by id', () {
      repository.add(customDestination('1', 'Bali', 'Indonesia'));
      repository.remove('1');
      expect(repository.all, isEmpty);
    });

    test('search matches name or country case-insensitively', () {
      repository.add(customDestination('1', 'Kyoto', 'Japan'));
      repository.add(customDestination('2', 'Lisbon', 'Portugal'));
      expect(repository.search('kyo').map((d) => d.id), contains('1'));
      expect(repository.search('PORTUGAL').map((d) => d.id), contains('2'));
      expect(repository.search(''), hasLength(2));
      expect(repository.search('zzz'), isEmpty);
    });

    test('seed data is deterministic and non-empty by default', () {
      final seeded = DestinationRepository();
      expect(seeded.all.length, greaterThanOrEqualTo(8));
      expect(seeded.all.first.id, 'bali');
    });
  });
}
