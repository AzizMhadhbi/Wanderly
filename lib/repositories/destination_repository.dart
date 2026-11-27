// `foundation.dart` also exports a `Category` annotation, so import only the
// notifier types to avoid an ambiguous name with our domain enum.
import 'package:flutter/foundation.dart' show ValueListenable, ValueNotifier;

import '../models/category.dart';
import '../models/destination.dart';

/// Single in-memory source of truth for destination data.
///
/// A [ValueNotifier] is used instead of a state-management package so screens
/// can rebuild reactively while the class stays trivially unit-testable.
/// Screens receive the same repository instance through constructor injection.
class DestinationRepository {
  DestinationRepository({List<Destination>? seed}) {
    _items.value = seed ?? _seedDestinations;
  }

  final ValueNotifier<List<Destination>> _items =
      ValueNotifier<List<Destination>>(<Destination>[]);

  /// Exposed for `ValueListenableBuilder` in the screens.
  ValueListenable<List<Destination>> get listenable => _items;

  /// Read-only snapshot of the current data.
  List<Destination> get all => List.unmodifiable(_items.value);

  List<Destination> get favourites =>
      _items.value.where((d) => d.isFavourite).toList(growable: false);

  void add(Destination destination) {
    _items.value = <Destination>[..._items.value, destination];
  }

  void remove(String id) {
    _items.value = _items.value.where((d) => d.id != id).toList(growable: false);
  }

  /// Replaces an item with the same id; no-ops when the id is unknown.
  void update(Destination destination) {
    final index = _items.value.indexWhere((d) => d.id == destination.id);
    if (index == -1) return;
    final next = List<Destination>.of(_items.value);
    next[index] = destination;
    _items.value = next;
  }

  void toggleFavourite(String id) {
    final index = _items.value.indexWhere((d) => d.id == id);
    if (index == -1) return;
    final next = List<Destination>.of(_items.value);
    next[index] = next[index].copyWith(isFavourite: !next[index].isFavourite);
    _items.value = next;
  }

  void setVisited(String id, bool visited) {
    final index = _items.value.indexWhere((d) => d.id == id);
    if (index == -1) return;
    final next = List<Destination>.of(_items.value);
    next[index] = next[index].copyWith(isVisited: visited);
    _items.value = next;
  }

  /// Case-insensitive match on name or country. An empty query returns all.
  List<Destination> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return _items.value
        .where((d) =>
            d.name.toLowerCase().contains(q) ||
            d.country.toLowerCase().contains(q))
        .toList(growable: false);
  }

  /// Resets back to the deterministic sample data (useful for tests/demo).
  void reset() => _items.value = List<Destination>.of(_seedDestinations);

  static final List<Destination> _seedDestinations = <Destination>[
    Destination(
      id: 'bali',
      name: 'Bali',
      country: 'Indonesia',
      category: Category.beach,
      description:
          'Volcanic islands, rice terraces and a laid-back surf culture.',
      imagePath: Category.beach.imagePath,
      latitude: -8.4095,
      longitude: 115.1889,
      websiteUrl: 'https://www.indonesia.travel/',
      rating: 4.8,
      isFavourite: true,
    ),
    Destination(
      id: 'kyoto',
      name: 'Kyoto',
      country: 'Japan',
      category: Category.culture,
      description:
          'Ancient temples, quiet gardens and traditional wooden streets.',
      imagePath: Category.culture.imagePath,
      latitude: 35.0116,
      longitude: 135.7681,
      websiteUrl: 'https://kyoto.travel/',
      rating: 4.9,
    ),
    Destination(
      id: 'banff',
      name: 'Banff',
      country: 'Canada',
      category: Category.mountain,
      description:
          'Glacier-fed lakes and dramatic peaks in the Canadian Rockies.',
      imagePath: Category.mountain.imagePath,
      latitude: 51.1784,
      longitude: -115.5708,
      websiteUrl: 'https://www.banffnationalpark.com/',
      rating: 4.7,
      isFavourite: true,
    ),
    Destination(
      id: 'lisbon',
      name: 'Lisbon',
      country: 'Portugal',
      category: Category.city,
      description:
          'Hillside viewpoints, tiled facades and Atlantic seafood.',
      imagePath: Category.city.imagePath,
      latitude: 38.7223,
      longitude: -9.1393,
      websiteUrl: 'https://www.visitlisboa.com/',
      rating: 4.6,
    ),
    Destination(
      id: 'amalfi',
      name: 'Amalfi Coast',
      country: 'Italy',
      category: Category.beach,
      description:
          'Cliffside villages and sunlit coves along the Tyrrhenian Sea.',
      imagePath: Category.beach.imagePath,
      latitude: 40.6287,
      longitude: 14.6028,
      rating: 4.7,
    ),
    Destination(
      id: 'cusco',
      name: 'Cusco',
      country: 'Peru',
      category: Category.culture,
      description:
          'Incan stonework, high-altitude trails and Andean markets.',
      imagePath: Category.culture.imagePath,
      latitude: -13.5320,
      longitude: -71.9675,
      rating: 4.5,
    ),
    Destination(
      id: 'dolomites',
      name: 'Dolomites',
      country: 'Italy',
      category: Category.mountain,
      description:
          'Pale limestone spires, alpine huts and world-class hiking.',
      imagePath: Category.mountain.imagePath,
      latitude: 46.4100,
      longitude: 11.8500,
      rating: 4.8,
      isVisited: true,
    ),
    Destination(
      id: 'copacabana',
      name: 'Copacabana',
      country: 'Brazil',
      category: Category.city,
      description:
          'A famous city beach framed by mountains and lively promenades.',
      imagePath: Category.city.imagePath,
      latitude: -22.9711,
      longitude: -43.1822,
      rating: 4.3,
    ),
  ];
}
