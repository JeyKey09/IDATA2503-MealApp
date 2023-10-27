import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals/models/meal.dart';

/// Notifier for the favorite meals
/// It is a StateNotifier, so it can be used as a provider
class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  /// Constructor, initializes the state with a empty list
  FavoriteMealsNotifier() : super([]);

  /// Toggles the favorite status of a meal
  /// Takes in a meal and returns a bool
  bool toggleMealFavoriteStatus(Meal meal) {
    // Checks if the meal is already in the list
    final mealIsFavorite = state.contains(meal);

    // If it is in the list, AKA if it is a favorite
    if (mealIsFavorite) {
      // Remove it from the list
      state = state.where((m) => m.id != meal.id).toList();
      // Return false, because it is not a favorite anymore
      return false;
    } else {
      // Add it to the list
      state = [...state, meal];
      // Return true, because it is a favorite now
      return true;
    }
  }
}

/// The provider for the favorite meals
final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
  return FavoriteMealsNotifier();
});
