import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals/models/meal.dart';
import 'package:meals/providers/favorites_provider.dart';

/// Screen for showing the meal details
class MealDetailsScreen extends ConsumerStatefulWidget {
  /// Constructor
  const MealDetailsScreen({
    super.key,
    required this.meal,
  });

  /// The meal to show
  final Meal meal;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MealDetailsScreenState();
  }
}

/// State for the meal details screen
class _MealDetailsScreenState extends ConsumerState<MealDetailsScreen> {
  /// list of bool that represent the steps done
  List<bool> _stepsDone = [];

  @override
  void initState() {
    super.initState();
    _stepsDone = List.generate(widget.meal.steps.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    // Fetches the favorite meals
    final favoriteMeals = ref.watch(favoriteMealsProvider);
    // Checks if the meal is a favorite
    final isFavorite = favoriteMeals.contains(widget.meal);

    return Scaffold(
        appBar: AppBar(title: Text(widget.meal.title), actions: [
          IconButton(
            onPressed: () {
              final wasAdded = ref
                  .read(favoriteMealsProvider.notifier)
                  .toggleMealFavoriteStatus(widget.meal);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      wasAdded ? 'Meal added as a favorite.' : 'Meal removed.'),
                ),
              );
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: Tween<double>(begin: 0.8, end: 1).animate(animation),
                  child: child,
                );
              },
              child: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                key: ValueKey(isFavorite),
              ),
            ),
          )
        ]),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: widget.meal.id,
                child: Image.network(
                  widget.meal.imageUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Ingredients',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 14),
              for (final ingredient in widget.meal.ingredients)
                Text(
                  ingredient,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              const SizedBox(height: 24),
              Text(
                'Steps',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 14),
              for (var i = 0; i < widget.meal.steps.length; i++)
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                          value: _stepsDone[i],
                          onChanged: (value) {
                            setState(() {
                              _stepsDone[i] = value!;
                            });
                          }),
                      Text(widget.meal.steps[i],
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  decoration: _stepsDone[i]
                                      ? TextDecoration.lineThrough
                                      : null,
                                  decorationThickness: 3)),
                    ]),
            ],
          ),
        ));
  }
}
