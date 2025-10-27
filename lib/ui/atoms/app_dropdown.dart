import 'package:flutter/material.dart';

import 'package:onepan/theme/tokens.dart';

class AppDropdown extends StatefulWidget {
  const AppDropdown({
    super.key,
    required this.label,
    required this.placeholder,
    required this.options,
    required this.value,
    required this.onChanged,
    this.errorText,
    this.semanticsLabel,
    this.fieldKey,
  });

  final String label;
  final String placeholder;
  final List<String> options;
  final String? value;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final String? semanticsLabel;
  // Optional key for the inner TextField to aid testing.
  final Key? fieldKey;

  @override
  State<AppDropdown> createState() => _AppDropdownState();
}

class _AppDropdownState extends State<AppDropdown> {
  late final TextEditingController _displayController;

  @override
  void initState() {
    super.initState();
    _displayController = TextEditingController(text: widget.value ?? '');
  }

  @override
  void didUpdateWidget(covariant AppDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _displayController.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }

  Future<void> _openSelector() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadii.lg),
        ),
      ),
      builder: (context) {
        return _DropdownSheet(
          options: widget.options,
          initialValue: widget.value,
          label: widget.label,
        );
      },
    );

    if (selected != null) {
      widget.onChanged(selected);
    }
  }

  InputBorder _buildBorder({required Color color, required double width}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.md),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hintStyle = AppTextStyles.body.copyWith(
      color: AppColors.onSurface.withValues(alpha: AppOpacity.mediumText),
    );

    final hasValue = (widget.value != null && widget.value!.isNotEmpty);
    return Semantics(
      label: widget.semanticsLabel ?? widget.label,
      textField: true,
      value: hasValue ? widget.value : null,
      hint: hasValue ? null : widget.placeholder,
      readOnly: true,
      onTap: _openSelector,
      // Ensure only this Semantics node contributes the accessible label,
      // not the inner TextField.
      child: ExcludeSemantics(
        child: TextField(
          key: widget.fieldKey,
          controller: _displayController,
          readOnly: true,
          style: AppTextStyles.body.copyWith(color: AppColors.onSurface),
          onTap: _openSelector,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.placeholder,
            hintStyle: hintStyle,
            suffixIcon: const Icon(
              Icons.arrow_drop_down,
              color: AppColors.onSurface,
              size: AppSizes.icon,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: _buildBorder(
                color: AppColors.onSurface, width: AppThickness.hairline),
            enabledBorder: _buildBorder(
                color: AppColors.onSurface, width: AppThickness.hairline),
            focusedBorder: _buildBorder(
                color: AppColors.primary, width: AppThickness.stroke),
            errorText: widget.errorText,
            errorStyle: AppTextStyles.label.copyWith(color: AppColors.danger),
          ),
        ),
      ),
    );
  }
}

class _DropdownSheet extends StatefulWidget {
  const _DropdownSheet({
    required this.options,
    required this.initialValue,
    required this.label,
  });

  final List<String> options;
  final String? initialValue;
  final String label;

  @override
  State<_DropdownSheet> createState() => _DropdownSheetState();
}

class _DropdownSheetState extends State<_DropdownSheet> {
  late final TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Iterable<String> get _filteredOptions {
    final lowercaseQuery = _query.toLowerCase();
    if (lowercaseQuery.isEmpty) {
      return widget.options;
    }
    return widget.options.where(
      (option) => option.toLowerCase().contains(lowercaseQuery),
    );
  }

  InputBorder _buildBorder({required Color color, required double width}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.md),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = _filteredOptions.toList();
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.xl,
          right: AppSpacing.xl,
          top: AppSpacing.lg,
          bottom: AppSpacing.lg + bottomPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              style: AppTextStyles.body.copyWith(color: AppColors.onSurface),
              decoration: InputDecoration(
                labelText: 'Search ${widget.label}',
                hintText: 'Type to filter',
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.onSurface
                      .withValues(alpha: AppOpacity.mediumText),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.onSurface
                      .withValues(alpha: AppOpacity.mediumText),
                  size: AppSizes.icon,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                filled: true,
                fillColor: AppColors.surface,
                border: _buildBorder(
                  color: AppColors.onSurface,
                  width: AppThickness.hairline,
                ),
                enabledBorder: _buildBorder(
                  color: AppColors.onSurface,
                  width: AppThickness.hairline,
                ),
                focusedBorder: _buildBorder(
                  color: AppColors.primary,
                  width: AppThickness.stroke,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: AppSpacing.xl * 10,
              ),
              child: options.isEmpty
                  ? Center(
                      child: Text(
                        'No matches found',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.onSurface
                              .withValues(alpha: AppOpacity.mediumText),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: options.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final option = options[index];
                        return _DropdownOptionTile(
                          label: option,
                          selected: option == widget.initialValue,
                          onTap: () => Navigator.of(context).pop(option),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DropdownOptionTile extends StatelessWidget {
  const _DropdownOptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected
        ? AppColors.primary.withValues(alpha: AppOpacity.focus)
        : AppColors.surface;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSizes.minTouchTarget,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style:
                        AppTextStyles.body.copyWith(color: AppColors.onSurface),
                  ),
                ),
                if (selected)
                  const Icon(
                    Icons.check,
                    color: AppColors.primary,
                    size: AppSizes.icon,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
