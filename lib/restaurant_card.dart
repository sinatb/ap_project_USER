import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:user/restaurant_page.dart';

class RestaurantCard extends StatelessWidget {

  final Restaurant restaurant;
  RestaurantCard(this.restaurant) : super();

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Material(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => RestaurantPage(restaurant)));
          },
          highlightColor: Theme.of(context).accentColor.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.only(right: 7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(restaurant.name, style: Theme.of(context).textTheme.headline6),
                    ...restaurant.foodCategories.map((e) => Text(Strings.get(e.toString())!, style: Theme.of(context).textTheme.caption))
                  ],
                  direction: Axis.vertical,
                  spacing: 3,
                ),
                buildScoreFill(restaurant.score),
              ],
            ),
          ),
        ),
      ),
    );
  }
  List<Widget> returnFoodCategory(FoodMenu m)
  {
    return <Widget>[
      for (var f in m.categories)
        Text(f.toString().substring(13) , style: TextStyle(fontSize: 10 , color: CommonColors.black),),
    ];
  }
}
