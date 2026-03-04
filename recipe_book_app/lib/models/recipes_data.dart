import '../models/recipe.dart';

final List<Recipe> sampleRecipes = [
  Recipe(
    name: 'Spaghetti Bolognese',
    imagePath: 'assets/images/pasta.jpg',
    ingredients: ['Spaghetti', 'Ground beef', 'Tomato sauce', 'Onion', 'Garlic'],
    instructions: 'Cook pasta. Brown beef with onion & garlic. Add sauce. Combine & serve.',
  ),
  Recipe(
    name: 'Chicken Curry',
    imagePath: 'assets/images/curry.jpg',
    ingredients: ['Chicken', 'Curry powder', 'Coconut milk', 'Onion', 'Garlic'],
    instructions: 'Sauté onion & garlic. Add chicken & curry powder. Pour coconut milk. Simmer until cooked.',
  ),
  Recipe(
    name: 'Vegetable Stir Fry',
    imagePath: 'assets/images/stirfry.jpg',
    ingredients: ['Mixed vegetables', 'Soy sauce', 'Garlic', 'Ginger', 'Sesame oil'],
    instructions: 'Heat oil. Add garlic & ginger. Stir fry vegetables. Add soy sauce. Serve with rice.',
  ),
  Recipe(
    name: 'Pancakes',
    imagePath: 'assets/images/pancakes.jpg',
    ingredients: ['Flour', 'Milk', 'Eggs', 'Sugar', 'Baking powder'],
    instructions: 'Mix dry ingredients. Add milk & eggs. Cook on griddle until golden.',
  ),
];