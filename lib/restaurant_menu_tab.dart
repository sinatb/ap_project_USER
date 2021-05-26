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
    return CustomScrollView(
      slivers: [
        for (var category in menu.categories)
          ...buildFoodsByCategory(menu.getFoods(category)!, category, context)
      ],
    );
  }

  List<Widget> buildFoodsByCategory(List<Food> foods, FoodCategory category, BuildContext context) {
    var headerStyle = Theme.of(context).textTheme.headline1!;
    return <Widget>[
      buildHeader(Strings.get(category.toString())!, headerStyle),
      SliverPadding(
        padding: const EdgeInsets.all(10.0),
        sliver: SliverGrid.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.7,
          children: foods.map((e) => FoodCard(e, orderedItems)).toList(growable: false),
        ),
      ),
    ];
  }
}
