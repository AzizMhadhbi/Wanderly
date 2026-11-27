import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Compact five-star rating indicator used on cards and detail views.
class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.showValue = true,
    this.iconSize = 16,
  });

  final double rating;
  final bool showValue;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final rounded = rating.round();
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: 'Rated $rating out of 5',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= 5; i++)
            Icon(
              i <= rounded ? Icons.star_rounded : Icons.star_border_rounded,
              color: warmCoral,
              size: iconSize,
            ),
          if (showValue) ...[
            const SizedBox(width: 6),
            Text(
              rating.toStringAsFixed(1),
              style: textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
