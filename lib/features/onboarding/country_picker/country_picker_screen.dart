import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:onepan/theme/tokens.dart';

class CountryPickerScreen extends ConsumerStatefulWidget {
  const CountryPickerScreen({super.key, required this.initial, required this.countries});
  final String? initial; // e.g., "Spain"
  final List<String> countries; // simple list for now

  @override
  ConsumerState<CountryPickerScreen> createState() => _CountryPickerScreenState();
}

class _CountryPickerScreenState extends ConsumerState<CountryPickerScreen> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.text.trim().toLowerCase();
    final items = q.isEmpty
        ? widget.countries
        : widget.countries.where((c) => c.toLowerCase().contains(q)).toList();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Select your country')),
      body: SafeArea(
        child: Column(
          children: [
            // Search (pinned)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: TextField(
                controller: _query,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search country',
                ),
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.search,
              ),
            ),
            // List
            Expanded(
              child: ListView.builder(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final name = items[i];
                  final selected = name == widget.initial;
                  return ListTile(
                    title: Text(name),
                    trailing: selected ? const Icon(Icons.check) : null,
                    onTap: () => Navigator.of(context).pop(name),
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

