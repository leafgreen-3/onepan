import 'package:flutter/material.dart';
import 'package:onepan/theme/tokens.dart';
import 'package:onepan/ui/atoms/atoms.dart';

class ComponentsDemoScreen extends StatefulWidget {
  const ComponentsDemoScreen({super.key});

  @override
  State<ComponentsDemoScreen> createState() => _ComponentsDemoScreenState();
}

class _ComponentsDemoScreenState extends State<ComponentsDemoScreen>
    with SingleTickerProviderStateMixin {
  bool loading = false;
  bool chipSelected = true;
  bool checklistChecked = false;
  String segment = 'fast';
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atoms Demo'),
        bottom: AppTabs(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Buttons'),
            Tab(text: 'Inputs'),
            Tab(text: 'Misc'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buttonsSection(context),
          _inputsSection(context),
          _miscSection(context, scheme),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Text(text, style: Theme.of(context).textTheme.titleLarge),
    );
  }

  Widget _buttonsSection(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _sectionTitle(context, 'AppButton'),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: loading ? 'Loading' : 'Primary',
                loading: loading,
                variant: AppButtonVariant.filled,
                size: AppButtonSize.lg,
                onPressed: () => setState(() => loading = !loading),
                expand: true,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: AppButton(
                label: 'Tonal',
                variant: AppButtonVariant.tonal,
                size: AppButtonSize.md,
                onPressed: () {},
                expand: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const AppButton(
          label: 'Text Button',
          variant: AppButtonVariant.text,
          onPressed: null,
        ),
      ],
    );
  }

  Widget _inputsSection(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _sectionTitle(context, 'Chips'),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            AppChip(
              label: 'Selectable',
              selected: chipSelected,
              onSelected: (v) => setState(() => chipSelected = v),
            ),
            AppChip(
              label: 'Filter',
              variant: AppChipVariant.filter,
              selected: !chipSelected,
              onSelected: (v) => setState(() => chipSelected = !v),
            ),
            const AppChip(label: 'Disabled', enabled: false),
          ],
        ),
        _sectionTitle(context, 'Checklist Tile'),
        AppCard(
          child: ChecklistTile(
            title: 'Olive Oil',
            subtitle: 'Pantry staple',
            checked: checklistChecked,
            onChanged: (v) => setState(() => checklistChecked = v),
            leading: const Icon(Icons.oil_barrel_outlined, size: AppSizes.icon),
          ),
        ),
        _sectionTitle(context, 'Segmented Control'),
        AppSegmentedControl<String>(
          segments: const [
            AppSegment(value: 'fast', label: 'Fast'),
            AppSegment(value: 'regular', label: 'Regular'),
            AppSegment(value: 'slow', label: 'Slow'),
          ],
          value: segment,
          onChanged: (v) => setState(() => segment = v),
        ),
      ],
    );
  }

  Widget _miscSection(BuildContext context, ColorScheme scheme) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _sectionTitle(context, 'Card + Skeleton'),
        AppCard(
          header: const Text('Recipe Card'),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                label: 'Action',
                variant: AppButtonVariant.text,
                onPressed: () {},
              ),
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppSkeleton.circle(size: AppSizes.minTouchTarget),
                  SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: AppSkeleton.rect(height: AppSpacing.xl),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg),
              AppSkeleton.rect(height: AppSizes.minTouchTarget),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        _sectionTitle(context, 'Tabs'),
        const SizedBox(
          height: AppSizes.minTouchTarget * 4,
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                AppTabs(tabs: [
                  Tab(text: 'One'),
                  Tab(text: 'Two'),
                  Tab(text: 'Three'),
                ]),
                Expanded(
                  child: TabBarView(children: [
                    Center(child: Text('One')),
                    Center(child: Text('Two')),
                    Center(child: Text('Three')),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


