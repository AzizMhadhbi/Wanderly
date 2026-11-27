import 'category.dart';

/// A place the user wants to (or has) visited.
///
/// Instances are treated as immutable: state changes (favourite / visited) go
/// through [copyWith] so that widgets holding an old instance are not mutated
/// behind their back.
class Destination {
  final String id;
  final String name;
  final String country;
  final Category category;
  final String description;
  final String imagePath;
  final double latitude;
  final double longitude;
  final String? websiteUrl;
  final double rating;
  final bool isFavourite;
  final bool isVisited;

  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.category,
    required this.description,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    this.websiteUrl,
    this.rating = 0,
    this.isFavourite = false,
    this.isVisited = false,
  });

  /// Returns a copy with selected fields replaced.
  Destination copyWith({
    String? id,
    String? name,
    String? country,
    Category? category,
    String? description,
    String? imagePath,
    double? latitude,
    double? longitude,
    String? websiteUrl,
    double? rating,
    bool? isFavourite,
    bool? isVisited,
    bool clearWebsiteUrl = false,
  }) {
    return Destination(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      category: category ?? this.category,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      websiteUrl: clearWebsiteUrl ? null : (websiteUrl ?? this.websiteUrl),
      rating: rating ?? this.rating,
      isFavourite: isFavourite ?? this.isFavourite,
      isVisited: isVisited ?? this.isVisited,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'country': country,
        'category': category.name,
        'description': description,
        'imagePath': imagePath,
        'latitude': latitude,
        'longitude': longitude,
        'websiteUrl': websiteUrl,
        'rating': rating,
        'isFavourite': isFavourite,
        'isVisited': isVisited,
      };

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
        id: json['id'] as String,
        name: json['name'] as String,
        country: json['country'] as String,
        category: CategoryX.fromName(json['category'] as String?),
        description: json['description'] as String? ?? '',
        imagePath: json['imagePath'] as String? ?? '',
        latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
        websiteUrl: json['websiteUrl'] as String?,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        isFavourite: json['isFavourite'] as bool? ?? false,
        isVisited: json['isVisited'] as bool? ?? false,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Destination &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          country == other.country &&
          category == other.category &&
          description == other.description &&
          imagePath == other.imagePath &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          websiteUrl == other.websiteUrl &&
          rating == other.rating &&
          isFavourite == other.isFavourite &&
          isVisited == other.isVisited;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        country,
        category,
        description,
        imagePath,
        latitude,
        longitude,
        websiteUrl,
        rating,
        isFavourite,
        isVisited,
      );

  @override
  String toString() => 'Destination($id: $name, $country)';
}
