import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'restaurant_card.dart';

class FavouriteRestaurantsPage extends StatefulWidget {
  @override
  _FavouriteRestaurantsPageState createState() => _FavouriteRestaurantsPageState();
}

class _FavouriteRestaurantsPageState extends State<FavouriteRestaurantsPage> {

  var loaded = false;
  var r = <Restaurant>[];

  @override
  Widget build(BuildContext context) {
    var user = Head.of(context).userServer.account;

    if (!loaded) {
      getAllRestaurants(user.favRestaurantIDs).then((value) => setState(() {
        loaded = true;
      }));
    }

    return Scaffold(
      body: loaded ? CustomScrollView (
        slivers: [
          SliverAppBar(
            floating: true,
            centerTitle: true,
            title: Text(Strings.get('fav-restaurants-app-bar')!, style: Theme.of(context).textTheme.headline5,),
            leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
              Navigator.pop(context);
            },),
          ),
          buildRestaurantList(r),
        ],
      ) : Center(child: Text('loading...'),),
    );
  }

  Widget buildRestaurantList(List<Restaurant> restaurants)
  {
    if (restaurants.isEmpty) {
      return SliverPadding(
        sliver: SliverToBoxAdapter(
          child: Center(child: Text(Strings.get('no-favorite-restaurants')!)),
        ),
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.5),
      );
    }
    return SliverPadding(
        padding: EdgeInsets.all(10),
        sliver: SliverList(
            delegate:SliverChildListDelegate(
              restaurants.map((restaurant) => RestaurantCard(restaurant)).toList(),
            )
        )
    );
  }

  Future<void> getAllRestaurants(List<String> restaurantIDs) async {
    var server = Head.of(context).server;
    for (var id in restaurantIDs) {
      r.add((await server.getObjectByID<Restaurant>(id)) as Restaurant);
    }
  }
}
