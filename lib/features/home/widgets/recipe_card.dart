import 'package:flutter/material.dart';
import 'package:onepan/models/recipe.dart';
import 'package:onepan/theme/tokens.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final Recipe recipe;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Recipe: ${recipe.title}',
      button: true,
      child: Material(
        color: scheme.surface,
        elevation: AppElevation.e1,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: scheme.primary.withValues(alpha: AppOpacity.hover),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _RecipeImage(title: recipe.title, imageUrl: recipe.image),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        scheme.scrim.withValues(alpha: AppOpacity.hover),
                        scheme.scrim.withValues(alpha: AppOpacity.focus),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: AppSpacing.xl,
                  right: AppSpacing.xl,
                  bottom: AppSpacing.xl,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          recipe.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.headline.copyWith(
                            color: scheme.surface,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      _TimeBadge(minutes: recipe.minutes),
                    ],
                  ),
                ),
                Positioned(
                  top: AppSpacing.lg,
                  right: AppSpacing.lg,
                  child: _FavoriteButton(
                    isFavorite: isFavorite,
                    onPressed: onToggleFavorite,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecipeImage extends StatelessWidget {
  const _RecipeImage({
    required this.title,
    required this.imageUrl,
  });

  final String title;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (imageUrl == null || imageUrl!.isEmpty) {
      return _PlaceholderImage(colorScheme: scheme);
    }

    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      semanticLabel: 'Recipe image: $title',
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return _PlaceholderImage(colorScheme: scheme);
      },
      errorBuilder: (context, _, __) {
        return _PlaceholderImage(colorScheme: scheme);
      },
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
      ),
      child: Center(
        child: Icon(
          Icons.restaurant_menu,
          size: AppSizes.icon,
          color: colorScheme.onSurface.withValues(alpha: AppOpacity.mediumText),
        ),
      ),
    );
  }
}

class _TimeBadge extends StatelessWidget {
  const _TimeBadge({required this.minutes});

  final int minutes;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: scheme.surface.withValues(alpha: AppOpacity.focus),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          '$minutes min',
          style: AppTextStyles.label.copyWith(
            color: scheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({
    required this.isFavorite,
    required this.onPressed,
  });

  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final iconColor = isFavorite
        ? scheme.primary
        : scheme.onSurface.withValues(alpha: AppOpacity.mediumText);

    return Semantics(
      button: true,
      label: isFavorite ? 'Remove from saved' : 'Save recipe',
      toggled: isFavorite,
      child: Material(
        color: scheme.surface.withValues(alpha: AppOpacity.focus),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              size: AppSizes.icon,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
