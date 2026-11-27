/// Broad categories used to classify a [Destination].
///
/// Keeping this as an enum makes the `Radio` selection in the add form
/// type-safe and avoids free-text values drifting apart.
enum Category { beach, city, mountain, culture }

extension CategoryX on Category {
  /// Human-readable label used in chips and form controls.
  String get label => switch (this) {
        Category.beach => 'Beach',
        Category.city => 'City',
        Category.mountain => 'Mountain',
        Category.culture => 'Culture',
      };

  /// Asset path for the representative category image.
  String get imagePath => switch (this) {
        Category.beach => 'assets/images/beach.jpg',
        Category.city => 'assets/images/city.jpg',
        Category.mountain => 'assets/images/mountain.jpg',
        Category.culture => 'assets/images/culture.jpg',
      };

  /// Parses a persisted category name, falling back to [Category.city].
  static Category fromName(String? name) {
    if (name == null) return Category.city;
    for (final value in Category.values) {
      if (value.name == name.toLowerCase()) return value;
    }
    return Category.city;
  }
}
