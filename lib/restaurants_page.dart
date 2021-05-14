import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'restaurant_card.dart';

class RestaurantsPage extends StatefulWidget {
  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {




  @override
  Widget build(BuildContext context) {
    List<Restaurant> r = Head.of(context).server.getRecommendedRestaurants();
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          centerTitle: true,
          title: Text(Strings.get('app-bar-restaurants')!),
          leading: IconButton(icon: Icon(Icons.search),tooltip: Strings.get('app-bar-leading-search'),onPressed: (){}),
        ),
        buildRestaurantList(r),
      ],
    );
  }

  Widget buildRestaurantList(List<Restaurant> restaurants)
  {
    return SliverPadding(
        padding: EdgeInsets.all(10),
        sliver: SliverList(
          delegate:SliverChildListDelegate(
            restaurants.map((restaurant) => RestaurantCard(restaurant)).toList(),
          )
        )
      );
  }
}
