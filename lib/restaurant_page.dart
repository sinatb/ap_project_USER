import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:user/food_card.dart';
class RestaurantPage extends StatefulWidget {
  final Restaurant restaurant;

  RestaurantPage(this.restaurant):super();
  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  Map<FoodData,int> ordersOfThisRestaurant = {};
  @override
  Widget build(BuildContext context) {
    FoodMenu menu = Head.of(context).server.getObjectByID(widget.restaurant.menuID!) as FoodMenu;
    return Scaffold(
        body: CustomScrollView(
          slivers: [
          SliverAppBar(
            floating: true,
            centerTitle: true,
            title: Text(widget.restaurant.name, style: TextStyle(fontSize: 24,
                fontWeight: FontWeight.bold,
                color: CommonColors.black),),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              tooltip: Strings.get('restaurant-page-return-tooltip'),
              onPressed: ()
              {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(icon: Icon(Icons.check , color: CommonColors.green,),
                tooltip: Strings.get('restaurant-page-accept-tooltip'),
                onPressed: ()
                {
                  if (ordersOfThisRestaurant.isNotEmpty) {
                    var server = Head.of(context).server;
                    var user = Head.of(context).server.account as UserAccount;
                    Order order = Order(
                        server: server,
                        customer: user.toCustomerData(Address()),
                        items: ordersOfThisRestaurant,
                        restaurant: widget.restaurant
                    );
                    user.cart.add(order);
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          buildRestaurantDataCard(widget.restaurant),
          buildHeader(Strings.get('restaurant-page-menu-header')!),
          buildMenu(menu),
        ],
      )
    );
  }

  Widget buildRestaurantDataCard(Restaurant r) {
    return SliverPadding(
      padding: EdgeInsets.all(10),
      sliver:SliverToBoxAdapter(
        child: Row(
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
            Spacer(),
            Text(
              r.name,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: CommonColors.black),
            ),
            Spacer(),
            Column(
              children: [
              Icon(
                  Icons.star_border,
                  color: CommonColors.black,
                ),
                Text(r.score.ceil().toString())
            ]
          ),
        ],
      )));
  }

  Widget buildMenu(FoodMenu menu)
  {
    return SliverGrid.count(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 0.7,
      children: [
        for (var food in menu.getFoods(FoodCategory.Iranian)!)
          FoodCard(food,ordersOfThisRestaurant,()=>setState((){})),
        for (var food in menu.getFoods(FoodCategory.FastFood)!)
          FoodCard(food,ordersOfThisRestaurant,()=>setState((){})),
        for (var food in menu.getFoods(FoodCategory.SeaFood)!)
          FoodCard(food,ordersOfThisRestaurant,()=>setState((){}))
      ],
    );
  }

}
