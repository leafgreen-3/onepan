import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:onepan/data/recipe_loader.dart';
import 'package:onepan/models/errors.dart';
import 'package:onepan/models/recipe.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads seeds and returns typed models', () async {
    final recipes = await loadRecipesFromAsset('assets/recipes.json');
    expect(recipes.length, greaterThanOrEqualTo(3));
    expect(recipes, isA<List<Recipe>>());
  });

  test('invalid seeds throw AggregateValidationError', () async {
    final original = await rootBundle.loadString('assets/recipes.json');
    final List<dynamic> data = jsonDecode(original) as List<dynamic>;

    // Clone first item and make it invalid
    final Map<String, dynamic> clone = Map<String, dynamic>.from(
      data.first as Map<String, dynamic>,
    );
    clone['minutes'] = 0; // invalid per schema 1..240
    data.add(clone);

    final alteredJson = jsonEncode(data);

    // Mock rootBundle for a distinct test path
    const codec = StringCodec();
    TestDefaultBinaryMessengerBinding
        .instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (ByteData? message) async {
      final String key = codec.decodeMessage(message!)!;
      if (key == 'assets/recipes_invalid.json') {
        final bytes = Uint8List.fromList(utf8.encode(alteredJson));
        return ByteData.view(bytes.buffer);
      }
      // Fall through to real asset loading for other keys
      return null;
    });

    await expectLater(
      () => loadRecipesFromAsset('assets/recipes_invalid.json'),
      throwsA(
        isA<AggregateValidationError>()
            .having(
              (e) => e.errors.any((err) => err.index == data.length - 1),
              'error references cloned item index',
              isTrue,
            )
            .having(
              (e) => e.errors.any((err) => (err.field).toString().isNotEmpty),
              'has a field name',
              isTrue,
            ),
      ),
    );

    // Cleanup mock handler to avoid cross-test interference
    TestDefaultBinaryMessengerBinding
        .instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
  });
}
