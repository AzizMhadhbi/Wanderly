import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Heart toggle with an immediate scale response and a semantic label.
class FavouriteButton extends StatelessWidget {
  const FavouriteButton({
    super.key,
    required this.isFavourite,
    required this.onTap,
    this.size = 40,
  });

  final bool isFavourite;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isFavourite,
      label: isFavourite ? 'Remove from saved' : 'Save destination',
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1, end: isFavourite ? 1.15 : 1),
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) => Transform.scale(
          scale: scale,
          child: child,
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFavourite ? Icons.favorite : Icons.favorite_border,
              color: isFavourite ? warmCoral : Colors.black54,
              size: size * 0.55,
            ),
          ),
        ),
      ),
    );
  }
}
