import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'food_card.dart';

class RestaurantMenuTab extends StatefulWidget {
  final Map<FoodData, int> orderedItems;
  final Restaurant restaurant;
  RestaurantMenuTab(this.restaurant, this.orderedItems) : super();

  @override
  _RestaurantMenuTabState createState() => _RestaurantMenuTabState();
}

class _RestaurantMenuTabState extends State<RestaurantMenuTab> {

  bool loaded = false;
  FoodMenu? menu;

  @override
  Widget build(BuildContext context) {

    if (!loaded) {
      getMenu(context).then((value) {
        menu = value;
        setState(() {
          loaded = true;
        });
      });
    }

    return CustomScrollView(
      slivers: loaded ? [
        if (menu!.isEmpty)
          SliverPadding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4.25),
            sliver: SliverToBoxAdapter(child: Center(child: Text(Strings.get('restaurant-menu-empty-message')!),),),
          )
        else
        for (var category in menu!.categories)
          ...buildFoodsByCategory(menu!.getFoods(category)!, category, context)
      ] : [
        SliverPadding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4.2),
          sliver: SliverToBoxAdapter(child: Center(child: Text('loading...'),),),
        )
    ],
    );
  }
  Future<FoodMenu> getMenu(BuildContext context) async{
    var menu = await Head.of(context).server.getObjectByID<FoodMenu>(widget.restaurant.menuID!) as FoodMenu;
    return menu;
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
          children: foods.map((e) => FoodCard(e, widget.orderedItems)).toList(growable: false),
        ),
      ),
    ];
  }
}
