import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals/data/dummy_data.dart';

/// Provider for the meals
final mealsProvider = Provider((ref) {
  return dummyMeals;
});
