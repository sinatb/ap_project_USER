import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'food_card.dart';

class RestaurantMenuTab extends StatelessWidget {

  final Map<FoodData, int> orderedItems;
  final Restaurant restaurant;
  RestaurantMenuTab(this.restaurant, this.orderedItems) : super();

  @override
  Widget build(BuildContext context) {
    var menu = Head.of(context).server.getObjectByID(restaurant.menuID!) as FoodMenu;
    return buildMenu(menu);
  }

  Widget buildMenu(FoodMenu menu) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 0.7,
      children: [
        for (var food in menu.getFoods(FoodCategory.Iranian)!)
          FoodCard(food, orderedItems, () => null),
        for (var food in menu.getFoods(FoodCategory.FastFood)!)
          FoodCard(food, orderedItems, () => null),
        for (var food in menu.getFoods(FoodCategory.SeaFood)!)
          FoodCard(food, orderedItems, () => null)
      ],
    );
  }
}
