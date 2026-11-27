import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/destination.dart';
import '../theme/app_theme.dart';
import 'category_chip.dart';
import 'favourite_button.dart';
import 'rating_stars.dart';

/// Gesture-enabled destination tile used by both Explore and Saved screens.
///
/// Gestures follow the specification:
/// - tap → open detail
/// - double tap → toggle favourite with immediate visual feedback
/// - long press → contextual delete confirmation
class DestinationCard extends StatelessWidget {
  const DestinationCard({
    super.key,
    required this.destination,
    required this.onTap,
    required this.onDoubleTap,
    required this.onLongPress,
  });

  final Destination destination;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: '${destination.name}, ${destination.country}. '
          '${destination.category.label}. Rating ${destination.rating} out of 5.',
      child: GestureDetector(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _DestinationImage(path: destination.imagePath),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xB3000000)],
                    stops: [0.35, 1.0],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: FavouriteButton(
                  isFavourite: destination.isFavourite,
                  onTap: onDoubleTap,
                  size: 36,
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      destination.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      destination.country,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CategoryChip(category: destination.category),
                        const SizedBox(width: 8),
                        const Spacer(),
                        RatingStars(rating: destination.rating),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows the local asset, with a coloured category fallback while assets are
/// still being added. This keeps the app runnable instead of throwing on a
/// missing image.
class _DestinationImage extends StatelessWidget {
  const _DestinationImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: oceanTeal,
        alignment: Alignment.center,
        child: const Icon(Icons.place_rounded, color: Colors.white54, size: 48),
      ),
    );
  }
}
