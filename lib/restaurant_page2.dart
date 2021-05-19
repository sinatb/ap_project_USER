import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'restaurant_page_header.dart';
import 'package:user/restaurant_menu_tab.dart';

class RestaurantPage extends StatefulWidget {
  final Restaurant restaurant;

  RestaurantPage(this.restaurant) : super();
  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  final orderedItems = <FoodData, int>{};

  final _tabs = <Tab>[
    Tab(text: 'Menu',),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, isInnerBoxScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: 150.0,
              flexibleSpace: buildFlexibleSpaceBar(),
              actions: [
                buildCheckoutIcon(),
              ],
            ),
            SliverPersistentHeader(
              delegate: RestaurantHeaderDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: _tabs,
                  labelColor: Theme.of(context).primaryColorDark,
                ),
                widget.restaurant,
              ),
              floating: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[RestaurantMenuTab(widget.restaurant, orderedItems)],
        ),
      ),
    );
  }

  IconButton buildCheckoutIcon() {
    return IconButton(icon: Icon(Icons.check),
      tooltip: Strings.get('restaurant-page-accept-tooltip'),
      onPressed: () {
        if (orderedItems.isNotEmpty) {
          var server = Head.of(context).server;
          var user = Head.of(context).server.account as UserAccount;
          Order order = Order(
              server: server,
              customer: user.toCustomerData(Address()),
              items: orderedItems,
              restaurant: widget.restaurant
          );
          user.cart.add(order);
        }
        ScaffoldMessenger.of(context).showSnackBar(
            showBar(Strings.get('foods-added-to-cart')!, Duration(milliseconds: 3000))
        );
        Navigator.pop(context);
      },
    );
  }

  FlexibleSpaceBar buildFlexibleSpaceBar() {
    return FlexibleSpaceBar(
      background: Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 13.0),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            children: [
              buildScoreFill(widget.restaurant.score),
              buildFavoriteButton(),
            ],
          ),
        ),
        alignment: Alignment.bottomRight,
      ),
      title: Text(widget.restaurant.name),
      centerTitle: true,
      collapseMode: CollapseMode.pin,
    );
  }

  buildFavoriteButton() {
    var fr = (Head.of(context).server.account as UserAccount).favRestaurantIDs;
    var index = fr.indexOf(widget.restaurant.id!);
    return IconButton(
      icon: Icon((index > -1) ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: Colors.pink,),
      onPressed: () {
        setState(() {
          if (index > -1) {
            fr.removeAt(index);
          } else {
            fr.add(widget.restaurant.id!);
          }
        });
      },
    );
  }

}
