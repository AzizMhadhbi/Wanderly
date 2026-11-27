import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/destination.dart';
import '../repositories/destination_repository.dart';
import '../widgets/category_chip.dart';
import '../widgets/favourite_button.dart';
import '../widgets/rating_stars.dart';

/// Read-only presentation of a destination plus platform actions.
/// Stateless: all mutable state is owned by the repository or the caller.
class DestinationDetailScreen extends StatelessWidget {
  const DestinationDetailScreen({
    super.key,
    required this.destination,
    required this.repository,
  });

  final Destination destination;
  final DestinationRepository repository;

  Uri get _mapsUri => Uri.parse(
        'https://www.google.com/maps/search/?api=1&query='
        '${destination.latitude},${destination.longitude}',
      );

  Future<void> _launch(BuildContext context, Uri uri) async {
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) throw const FormatException('No app could open the link');
    } on Object {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open this link')),
      );
    }
  }

  void _share() {
    Share.share(
      '${destination.name}, ${destination.country} — '
      '${destination.description}',
      subject: 'A place from my Wanderly list',
    );
  }

  void _toggleFavourite() =>
      repository.toggleFavourite(destination.id);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final current = repository.all.firstWhere(
      (d) => d.id == destination.id,
      orElse: () => destination,
    );

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 290,
                width: double.infinity,
                child: Image.asset(
                  destination.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: colors.primary,
                    child: const Icon(Icons.place, size: 72, color: Colors.white54),
                  ),
                ),
              ),
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black26,
                        Colors.transparent,
                        Colors.black54,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: IconButton(
                    tooltip: 'Back',
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                right: 8,
                child: FavouriteButton(
                  isFavourite: current.isFavourite,
                  onTap: _toggleFavourite,
                  size: 44,
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.name,
                      style: textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      destination.country,
                      style: textTheme.titleMedium
                          ?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CategoryChip(category: destination.category),
                      const SizedBox(width: 12),
                      RatingStars(rating: destination.rating),
                      const Spacer(),
                      if (current.isVisited)
                        const Tooltip(
                          message: 'Visited',
                          child: Icon(Icons.check_circle, color: Colors.green),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    destination.description,
                    style: textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined),
                              const SizedBox(width: 12),
                              Text(
                                '${destination.latitude.toStringAsFixed(4)}, '
                                '${destination.longitude.toStringAsFixed(4)}',
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _launch(context, _mapsUri),
                              icon: const Icon(Icons.map),
                              label: const Text('Open in Maps'),
                            ),
                          ),
                          if (destination.websiteUrl != null) ...[
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => _launch(
                                  context,
                                  Uri.parse(destination.websiteUrl!),
                                ),
                                icon: const Icon(Icons.language),
                                label: const Text('Visit website'),
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton.icon(
                              onPressed: _share,
                              icon: const Icon(Icons.share),
                              label: const Text('Share destination'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
