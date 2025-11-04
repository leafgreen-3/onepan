import 'package:flutter_test/flutter_test.dart';
import 'package:onepan/services/ingredient_catalog/ingredient_catalog_service.dart';

void main() {
  // Ensure binding so asset loading via rootBundle works in tests.
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads and resolves names/images', () async {
    final svc = IngredientCatalogService();
    await svc.init(); // uses default asset path
    expect(svc.isReady, true);

    expect(svc.has('chickpea'), true);
    expect(svc.displayName('chickpea'), isNotEmpty);

    // alias resolution
    expect(svc.resolveId('garbanzo'), 'chickpea');

    // image provider may be null if asset not present yet (that’s fine)
    final _ = svc.imageProvider('spinach');
    // no assertion on value; just ensure no throw.
  });

  test('fallback for unknown id', () async {
    final svc = IngredientCatalogService();
    await svc.init();
    expect(svc.displayName('unknown123'), 'unknown123');
    // imageProvider now returns a convention-based AssetImage; just ensure no throw.
    final _ = svc.imageProvider('unknown123');
  });
}
