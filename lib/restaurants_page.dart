import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'restaurant_card.dart';

class RestaurantsPage extends StatefulWidget {
  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {

  bool Function(Restaurant)? _filter;
  int Function(Restaurant, Restaurant)? _sortOrder;
  int _selectedChip = 0;
  var chips = ['None', 'Closest', 'Score'];

  @override
  Widget build(BuildContext context) {

    var server = Head.of(context).server;
    List<Restaurant> r = server.getRecommendedRestaurants(_filter);
    r = server.sortRecommendedRestaurants(r, _sortOrder);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          centerTitle: true,
          title: Text(Strings.get('app-bar-restaurants')!),
          leading: IconButton(icon: Icon(Icons.search),tooltip: Strings.get('app-bar-leading-search'),onPressed: (){}),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.all(6.0),
            width: MediaQuery.of(context).size.width,
            child: Text('Sort the results based on:', style: Theme.of(context).textTheme.bodyText1),
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          sliver: SliverToBoxAdapter(
            child: Wrap(
              spacing: 10,
              children: List<Widget>.generate(chips.length, (index) => buildChoiceChip(index)),
            ),
          ),
        ),
        buildRestaurantList(r),
      ],
    );
  }

  Widget buildRestaurantList(List<Restaurant> restaurants) {
    return SliverPadding(
        padding: EdgeInsets.all(10),
        sliver: SliverList(
          delegate:SliverChildListDelegate(
            restaurants.map((restaurant) => RestaurantCard(restaurant)).toList(),
          )
        )
      );
  }

  buildChoiceChip(int index) {
    return ChoiceChip(
      label: Text(chips[index]),
      selected: index == _selectedChip,
      onSelected: (isSelected) => setState(() {
        _selectedChip = isSelected ? index : _selectedChip;
        changeSortOrder();
      }),
    );
  }

  void changeSortOrder() {
    var user = Head.of(context).server.account as UserAccount;
    double latitude = user.addresses[user.defaultAddress]!.latitude;
    double longitude = user.addresses[user.defaultAddress]!.longitude;
    switch(_selectedChip) {
      case 0:
        _sortOrder = null;
        break;
      case 2:
        _sortOrder = Server.onScore;
        break;
      case 1:
        _sortOrder = Server.createOnDistance(latitude, longitude);
        break;
    }
  }
}
