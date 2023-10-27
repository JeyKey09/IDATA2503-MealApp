import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals/providers/meals_provider.dart';

/// Different of filters alternatives
enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

/// Notifier for the filters
class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  /// Constructor, initializes the state with every filter as false
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false
        });

  ///Method to set a filter to a specific value
  /// Takes in a map of filters and bools
  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }

  /// Method to set a specific filter to bool
  /// Takes in a filter and a bool
  void setFilter(Filter filter, bool isActive) {
    // state[filter] = isActive; // not allowed! => mutating state
    state = {
      ...state,
      filter: isActive,
    };
  }
}

/// Provider to tell if a filter has changed
final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) => FiltersNotifier(),
);

/// Provider to filter the meals
final filteredMealsProvider = Provider((ref) {
  /// Watch if the meals has changed
  final meals = ref.watch(mealsProvider);

  /// Watch if the filters has changed
  final activeFilters = ref.watch(filtersProvider);

  /// Filters the meals based on the active filters
  /// TODO: To high coupling between filters and meals. If a filter is added, it has to be added here too and to the meals as it is own property
  return meals.where((meal) {
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
