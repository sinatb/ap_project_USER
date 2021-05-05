import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:user/restaurant_page.dart';
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
    FoodMenu menu = Head.of(context).server.getObjectByID(widget.r.menuID!) as FoodMenu;
    return Card(
        child: Row(
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            Spacer(),
            Column(
              children:[
                Text(restaurant.name , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold , color: CommonColors.blue),),
                ...returnFoodCategory(menu),
              ]
            ),
            Spacer(),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.star_border , color: CommonColors.black,),
                    Text(restaurant.score.ceil().toString()),
                  ],
                ),
              buildModelButton(Strings.get('restaurant-card-inf')!,CommonColors.green!, (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RestaurantPage(restaurant)));
              }),
              ],
            )
          ],
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
