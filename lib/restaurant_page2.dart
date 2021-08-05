import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'order_card.dart';
import 'restaurant_page_header.dart';
import 'restaurant_menu_tab.dart';
import 'restaurant_comments_tab.dart';

class RestaurantPage extends StatefulWidget {
  final Restaurant restaurant;
  final bool isInArea;
  RestaurantPage(this.restaurant, this.isInArea) : super();
  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  final orderedItems = <FoodData, int>{};

  final _tabs = <Tab>[
    Tab(text: Strings.get('restaurant-page-menu-header'),),
    Tab(text: Strings.get('comments-tab-title')),
    Tab(text: Strings.get('orders-previous-orders-heading'),),
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
                  isScrollable: false,
                  labelColor: Theme.of(context).primaryColorDark,
                ),
                widget.restaurant,
                widget.isInArea
              ),
              floating: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            RestaurantMenuTab(widget.restaurant, orderedItems),
            RestaurantComments(widget.restaurant.commentIDs),
            buildPreviousOrdersTab(),
          ],
        ),
      ),
    );
  }
  IconButton buildCheckoutIcon() {
    return IconButton(icon: Icon(Icons.check),
      tooltip: Strings.get('restaurant-page-accept-tooltip'),
      onPressed: () {
        if (orderedItems.isNotEmpty) {
          var server = Head.of(context).userServer;
          var user = server.account;
          Order order = Order(
              server: server,
              customer: user.toCustomerData(user.defaultAddress!),
              items: orderedItems,
              restaurant: widget.restaurant
          );
          //order does not have a serial is this ok ?? :/     - yes :)
          user.addToCart(order);
          ScaffoldMessenger.of(context).showSnackBar(
              showBar(Strings.get('foods-added-to-cart')!, Duration(milliseconds: 3000))
          );
        }
        Navigator.pop(context);
      },
    );
  }

  FlexibleSpaceBar buildFlexibleSpaceBar() {
    return FlexibleSpaceBar(
      background: Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 7.0),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 2,
            children: [
              buildFavoriteButton(),
            ],
          ),
        ),
        alignment: Alignment.bottomRight,
      ),
      title: Text(widget.restaurant.name, style: Theme.of(context).textTheme.headline1!),
      centerTitle: true,
      collapseMode: CollapseMode.pin,
    );
  }
  // changes where made to list without invoking edit !
  buildFavoriteButton() {
    var user = Head.of(context).userServer.account;
    var fr = user.favRestaurantIDs;
    var index = fr.indexOf(widget.restaurant.id!);
    return IconButton(
      icon: Icon((index > -1) ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: Colors.pink,),
      onPressed: () {
        setState(() {
          if (index > -1) {
            user.removeRestaurant(widget.restaurant.id!);
          } else {
            user.addRestaurant(widget.restaurant.id!);
          }
        });
      },
    );
  }

  buildPreviousOrdersTab() {
    var orders = Head.of(context).userServer.account.previousOrders
    .where((order) => order.restaurant.id == widget.restaurant.id);
    if (orders.isEmpty) {
      return Center(
        child: Text(Strings.get('orders-no-previous-orders')!),
      );
    }
    return ListView(
      children: orders.map((e) => OrderCard(e)).toList(growable: false),
    );
  }

}
