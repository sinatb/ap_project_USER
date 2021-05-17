import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:user/restaurant_card.dart';

class FavouriteRestaurantsPage extends StatefulWidget {
  @override
  _FavouriteRestaurantsPageState createState() => _FavouriteRestaurantsPageState();
}

class _FavouriteRestaurantsPageState extends State<FavouriteRestaurantsPage> {
  @override
  Widget build(BuildContext context) {
    var user = (Head.of(context).server.account as UserAccount);
    var listID = user.favRestaurantIDs;
    List<Restaurant> favRestaurants = List.generate(listID.length, (index) => Head.of(context).server.getObjectByID(listID.elementAt(index)) as Restaurant);
    return Scaffold(body:
        CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              centerTitle: true,
              title: Text(Strings.get('fav-restaurants-app-bar')!),
              leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
                Navigator.pop(context);
              },),
              actions: [
                  IconButton(icon: Icon(Icons.search),tooltip: Strings.get('app-bar-leading-search'),onPressed: (){}),
              ],
            ),
            buildRestaurantList(favRestaurants),
          ],
        )
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
