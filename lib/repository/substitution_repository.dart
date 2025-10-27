import 'package:onepan/models/substitution.dart';

/// Contract for ingredient substitution service.
abstract class SubstitutionRepository {
  Future<SubstitutionResponse> substitute(SubstitutionRequest req);
}

