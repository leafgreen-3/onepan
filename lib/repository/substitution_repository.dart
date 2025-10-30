import 'package:onepan/models/substitution.dart';

/// Contract for ingredient substitution service.
// TODO(legacy): Remove after MVP once all references are gone.
abstract class SubstitutionRepository {
  Future<SubstitutionResponse> substitute(SubstitutionRequest req);
}

