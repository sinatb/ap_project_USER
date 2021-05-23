import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:user/restaurant_page2.dart';

class RestaurantCard extends StatelessWidget {

  final Restaurant restaurant;
  RestaurantCard(this.restaurant) : super();

  @override
  Widget build(BuildContext context) {

    var server = Head.of(context).server;
    var user = server.account as UserAccount;
    var isInArea = server.isInArea(user.defaultAddress!, restaurant.address, restaurant.areaOfDispatch);
    return Card(
      child: Material(
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
                  child:restaurant.logo,
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

  List<Widget> returnFoodCategory(FoodMenu m) {
    return <Widget>[
      for (var f in m.categories)
        Text(f.toString().substring(13) , style: TextStyle(fontSize: 10 , color: CommonColors.black),),
    ];
  }
}
