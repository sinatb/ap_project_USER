import 'package:flutter/material.dart';
import 'package:models/models.dart';
class RestaurantCard extends StatefulWidget {
  final Restaurant r;

  RestaurantCard(this.r):super();
  @override
  _RestaurantCardState createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  @override
  Widget build(BuildContext context) {
    var restaurant = widget.r;
    return Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            Column(
              children:[
                Text(restaurant.name , style: TextStyle(fontSize: 24 , fontWeight: FontWeight.bold , color: CommonColors.blue),),
                ...returnFoodCategory(restaurant),
              ]
            ),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.star_border , color: CommonColors.black,),
                    Text(restaurant.score.toString()),
                  ],
                ),
              buildModelButton(Strings.get('restaurant-card-inf')!,CommonColors.green!, (){})
              ],
            )
          ],
        ),
    );
  }

  List<Widget> returnFoodCategory(Restaurant r)
  {
    return <Widget>[
      for (var f in widget.r.foodCategories)
        Text(f.toString().substring(13) , style: TextStyle(fontSize: 10 , color: CommonColors.black),),
    ];
  }
}
