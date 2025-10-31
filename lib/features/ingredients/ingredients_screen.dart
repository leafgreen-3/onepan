import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:onepan/data/models/recipe.dart' as model_v1;
import 'package:onepan/features/ingredients/ingredients_providers.dart';
import 'package:onepan/features/ingredients/ingredient_index.dart';
import 'package:onepan/features/recipe/recipe_providers.dart';
import 'package:onepan/theme/tokens.dart';
import 'package:onepan/ui/atoms/app_button.dart';
import 'package:onepan/ui/atoms/checklist_tile.dart';

class IngredientsScreen extends ConsumerWidget {
  const IngredientsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(filteredGroupsProvider);
    final selected = ref.watch(selectedIngredientIdsProvider);
    final setSelected = ref.read(selectedIngredientIdsProvider.notifier);
    final indexAsync = ref.watch(ingredientIndexProvider);

    // Expect payload: { recipeId, customize }
    final extra = GoRouterState.of(context).extra;
    final payload = (extra is Map) ? extra : const {};
    final recipeId = payload['recipeId'] as String?;
    final customize = payload['customize'];
    final AsyncValue<model_v1.Recipe?> recipeAsync =
        (recipeId != null && recipeId.isNotEmpty)
            ? ref.watch(recipeByIdProvider(recipeId))
            : const AsyncValue<model_v1.Recipe?>.data(null);

    // Default selection: select core items once after index loads (avoid mutating during build)
    ref.listen(ingredientIndexProvider, (prev, next) {
      next.whenData((index) {
        final current = ref.read(selectedIngredientIdsProvider);
        if (current.isEmpty) {
          final core = index.groups.firstWhere(
            (g) => g.key == 'header_core',
            orElse: () => IngredientGroup(key: 'header_core', title: 'Core', items: const []),
          );
          ref.read(selectedIngredientIdsProvider.notifier).setAll(core.items.map((e) => e.id));
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredients'),
        centerTitle: true,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _SearchField(
              onChanged: (q) =>
                  ref.read(searchQueryProvider.notifier).state = q,
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: recipeAsync.when(
                data: (recipe) {
                  List<IngredientGroup> visible = groups;
                  if (recipe != null) {
                    final idSet = recipe.ingredients.map((e) => e.id).toSet();
                    visible = [
                      for (final g in groups)
                        IngredientGroup(
                          key: g.key,
                          title: g.title,
                          items: g.items
                              .where((it) => idSet.contains(it.id))
                              .toList(growable: false),
                        )
                    ];
                    // Demo tweak: for miso-ginger-tofu-skillet, cap each section to 2 items
                    if (recipe.id == 'miso-ginger-tofu-skillet') {
                      visible = [
                        for (final g in visible)
                          IngredientGroup(
                            key: g.key,
                            title: g.title,
                            items: g.items.take(2).toList(growable: false),
                          )
                      ];
                    }
                    // Remove empty groups
                    visible = [for (final g in visible) if (g.items.isNotEmpty) g];
                  }

                  return _GroupsList(
                    groups: visible,
                    selectedIds: selected,
                    onToggle: (id) => setSelected.toggle(id),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(
                  child: Text('Could not load recipe'),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.lg),
          child: AppButton(
            key: const Key('ing_next'),
            label: 'Next',
            expand: true,
            onPressed: () async {
              // Compute available/missing using selected ids and recipe ingredients
              final availableIds = selected.toList(growable: false);
              final id = recipeId ?? '';
              final recipe = (id.isNotEmpty)
                  ? await ref.read(recipeByIdProvider(id).future)
                  : null;
              final missingIds = (recipe?.ingredients
                          .map((e) => e.id)
                          .where((id) => !availableIds.contains(id))
                          .toList(growable: false)) ??
                  const <String>[];

              context.push('/finalizer', extra: {
                'recipeId': id,
                'customize': customize,
                'availableIds': availableIds,
                'missingIds': missingIds,
              });
            },
          ),
        ),
      ),
    );
  }
}

class _SearchField extends ConsumerWidget {
  const _SearchField({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _SearchFieldStateful(onChanged: onChanged);
  }
}

class _SearchFieldStateful extends ConsumerStatefulWidget {
  const _SearchFieldStateful({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  ConsumerState<_SearchFieldStateful> createState() => _SearchFieldStatefulState();
}

class _SearchFieldStatefulState extends ConsumerState<_SearchFieldStateful> {
  late final TextEditingController _controller;
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(searchQueryProvider));
    _listener = () {
      final value = _controller.text;
      if (ref.read(searchQueryProvider) != value) {
        ref.read(searchQueryProvider.notifier).state = value;
        widget.onChanged(value);
      }
    };
    _controller.addListener(_listener);
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: TextField(
        key: const Key('ing_search'),
        controller: _controller,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search ingredients',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: scheme.surfaceContainerLow,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
            borderSide: BorderSide(color: scheme.outlineVariant),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
    );
  }
}

class _GroupsList extends ConsumerWidget {
  const _GroupsList({
    required this.groups,
    required this.selectedIds,
    required this.onToggle,
  });

  final List<IngredientGroup> groups;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (groups.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    final query = ref.watch(searchQueryProvider).trim();
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final g = groups[index];
        final isSearch = query.isNotEmpty && g.key == 'header_results';
        return _GroupSection(
          headerKey: g.key,
          title: g.title,
          items: g.items,
          selectedIds: selectedIds,
          onToggle: onToggle,
          isSearchMode: isSearch,
        );
      },
    );
  }
}

class _GroupSection extends ConsumerWidget {
  const _GroupSection({
    required this.headerKey,
    required this.title,
    required this.items,
    required this.selectedIds,
    required this.onToggle,
    this.isSearchMode = false,
  });

  final String headerKey;
  final String title;
  final List<dynamic> items; // v1.Ingredient
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;
  final bool isSearchMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final groupName = headerKey.startsWith('header_')
        ? headerKey.substring('header_'.length)
        : headerKey;
    final collapsed = isSearchMode
        ? false
        : (ref.watch(collapseStateProvider(null))[groupName] == false);
    final toggle = () =>
        ref.read(collapseStateProvider(null).notifier).toggle(groupName);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          key: Key('toggle_$groupName'),
          behavior: HitTestBehavior.opaque,
          onTap: isSearchMode ? null : toggle,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    key: Key(headerKey),
                    style: AppTextStyles.title.copyWith(color: scheme.onSurface),
                  ),
                ),
                if (!isSearchMode)
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: collapsed ? -0.25 : 0.0, // right when collapsed, down when expanded
                    child: Icon(
                      Icons.expand_more,
                      color: scheme.onSurface.withValues(alpha: AppOpacity.mediumText),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Material(
          color: scheme.surface,
          elevation: AppElevation.e1,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: collapsed
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      for (final dynamic it in items)
                        _IngredientRow(
                          id: it.id as String,
                          title: it.name as String,
                          thumbAsset: (it.thumbAsset as String?) ??
                              'assets/images/ingredients/placeholder.png',
                          checked: selectedIds.contains(it.id as String),
                          onChanged: () => onToggle(it.id as String),
                        ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    required this.id,
    required this.title,
    required this.thumbAsset,
    required this.checked,
    required this.onChanged,
  });

  final String id;
  final String title;
  final String thumbAsset;
  final bool checked;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return ChecklistTile(
      key: Key('ing_row_$id'),
      checkboxKey: Key('ing_check_$id'),
      title: title,
      checked: checked,
      onChanged: (_) => onChanged(),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: Image.asset(
          thumbAsset,
          width: AppSizes.minTouchTarget,
          height: AppSizes.minTouchTarget,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}


