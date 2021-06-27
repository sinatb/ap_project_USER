import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'restaurant_card.dart';
import 'restaurant_search.dart';

class RestaurantsPage extends StatefulWidget {
  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {

  final predicate = RestaurantPredicate();
  List<Restaurant> _r = [];
  int Function(Restaurant, Restaurant)? _sortOrder;
  int _selectedChip = 0;
  int? _selectedCategory;
  final chips = ['None', 'Closest', 'Score', 'test a', 'test b', 'test c', 'test d', 'test e'];
  var isLoaded = false;
  final categories = [
    ...FoodCategory.values,
    ...FoodCategory.values,
  ];

  @override
  Widget build(BuildContext context) {

    var server = Head.of(context).server;
    if (predicate.isNull) {
      if (!isLoaded) {
        server.getRecommendedRestaurants().then((value) async {
            _r = value ;
            setState(() {
              isLoaded = true;
            });
        });
      }
    } else {
      if (!isLoaded) {
        server.filterRecommendedRestaurants(predicate).then((value) async {
          _r = value;
          setState(() {
            isLoaded = true;
          });
        });
      }
    }

    _r = server.sortRecommendedRestaurants(_r, _sortOrder);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          centerTitle: true,
          title: Text(Strings.get('app-bar-restaurants')! , style: Theme.of(context).textTheme.headline1,),
          leading: predicate.isNull ? IconButton(icon: Icon(Icons.search,color: Theme.of(context).iconTheme.color,),tooltip: Strings.get('app-bar-leading-search'), onPressed: searchPressed)
          : IconButton(icon: Icon(Icons.close,color: Theme.of(context).iconTheme.color,), onPressed: () => setState(() {
            predicate.setNull();
          })),
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
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List<Widget>.generate(chips.length, (index) => Padding(padding: EdgeInsets.symmetric(horizontal: 2.0), child: buildChoiceChip(index))),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List<Widget>.generate(categories.length, (index) => buildCategoryCard(index)),
            ),
          ),
        ),
        buildRestaurantList(_r),
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
    double latitude = user.defaultAddress!.latitude;
    double longitude = user.defaultAddress!.longitude;
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

  void searchPressed() async {
    var result = await showModalBottomSheet(context: context, builder: (context) => SearchSheet(predicate));
    if (result == true) {
      setState(() {});
    }
  }

  Widget buildCategoryCard(int index) {
    var isSelected = _selectedCategory == index;
    var category = categories[index];
    var aspectRatio = 3/2;
    var width = isSelected ? 160.0 : 150.0;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedCategory = null;
            predicate.category = null;
          } else {
            _selectedCategory = index;
            predicate.category = category;
          }
        });
      },
      child: AnimatedContainer(
        width: width,
        height: width / aspectRatio,
        margin: EdgeInsets.only(right: 9),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: getCardShadow(isSelected),
          // image: category image
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 5,
          child: Container(
            height: width/10,
            child: Text(Strings.get(category.toString()) ?? 'unknown category', style: TextStyle(color: Theme.of(context).cardColor),),
            color: Colors.black.withOpacity(0.3),
            alignment: Alignment.center,
          ),
        ),
        alignment: Alignment.bottomCenter,
        duration: Duration(milliseconds: 200),
      ),
    );
  }

  getCardShadow(bool isSelected) {
    if (isSelected) {
      return [BoxShadow(blurRadius: 0, spreadRadius: 5, color: Theme.of(context).accentColor.withOpacity(0.4))];
    }
    return [BoxShadow(blurRadius: 5, spreadRadius: 1, color: Theme.of(context).shadowColor.withOpacity(0.2))];
  }

}
