import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'restaurant_page2.dart';

class RestaurantCard extends StatelessWidget {

  final Restaurant restaurant;
  RestaurantCard(this.restaurant) : super();

  @override
  Widget build(BuildContext context) {

    var server = Head.of(context).userServer;
    var user = server.account;
    var isInArea = server.isInArea(user.defaultAddress!, restaurant.address, restaurant.areaOfDispatch);
    return Card(
      child: Material(
        color: Theme.of(context).cardColor,
        shape: Theme.of(context).cardTheme.shape,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => RestaurantPage(restaurant, isInArea)));
          },
          highlightColor: Theme.of(context).accentColor.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.only(right: 7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Image.asset('assets/default_restaurant.jpg' , package: 'models',),
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(restaurant.name, style: Theme.of(context).textTheme.headline6),
                      ...restaurant.foodCategories.map((e) => Text(Strings.get(e.toString())!, style: Theme.of(context).textTheme.caption))
                    ],
                    direction: Axis.vertical,
                    spacing: 3,
                  ),
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    buildScoreFill(restaurant.score),
                    buildArea(isInArea),
                  ],
                  direction: Axis.vertical,
                  spacing: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
