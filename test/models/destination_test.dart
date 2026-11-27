import 'package:flutter_test/flutter_test.dart';
import 'package:wanderly/models/category.dart';
import 'package:wanderly/models/destination.dart';

Destination buildDestination() => const Destination(
      id: 'test-1',
      name: 'Kyoto',
      country: 'Japan',
      category: Category.culture,
      description: 'Temples and gardens.',
      imagePath: 'assets/images/culture.jpg',
      latitude: 35.0116,
      longitude: 135.7681,
      websiteUrl: 'https://kyoto.travel/',
      rating: 4.9,
    );

void main() {
  group('Destination', () {
    test('copyWith changes only the supplied fields', () {
      final original = buildDestination();
      final updated = original.copyWith(isFavourite: true, rating: 5.0);

      expect(updated.id, original.id);
      expect(updated.name, original.name);
      expect(updated.isFavourite, isTrue);
      expect(updated.rating, 5.0);
      expect(original.isFavourite, isFalse, reason: 'original must stay unchanged');
    });

    test('copyWith can explicitly clear the optional website URL', () {
      final updated = buildDestination().copyWith(clearWebsiteUrl: true);
      expect(updated.websiteUrl, isNull);
    });

    test('toJson / fromJson round trip preserves all fields', () {
      final original = buildDestination().copyWith(isFavourite: true);
      final restored = Destination.fromJson(original.toJson());
      expect(restored, equals(original));
    });

    test('fromJson falls back safely for unknown categories', () {
      final json = buildDestination().toJson()..['category'] = 'unknown';
      expect(Destination.fromJson(json).category, Category.city);
    });
  });
}
