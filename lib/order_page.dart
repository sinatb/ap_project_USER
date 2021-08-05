import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'order_card.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {


  @override
  Widget build(BuildContext context) {

    var server = Head.of(context).userServer;
    var activeOrders = server.account.activeOrders;
    var previousOrders = server.account.previousOrders;

    final headerStyle = Theme.of(context).textTheme.headline1!.copyWith(color: Theme.of(context).colorScheme.secondaryVariant);

    return RefreshIndicator(
      onRefresh: refreshList,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            centerTitle: true,
            title: Text(Strings.get('orders-app-bar')!,style: Theme.of(context).textTheme.headline1,),
          ),
          buildHeader(Strings.get('orders-active-orders-heading')!, headerStyle),
          activeOrders.isNotEmpty ?
            buildRestaurantList(activeOrders) :
            buildEmptyListMessage(Strings.get('orders-no-active-orders')!),
          buildHeader(Strings.get('orders-previous-orders-heading')!, headerStyle),
          previousOrders.isNotEmpty ?
            buildRestaurantList(previousOrders) :
            buildEmptyListMessage(Strings.get('orders-no-previous-orders')!),
        ],
      ),
    );
  }

  SliverToBoxAdapter buildEmptyListMessage(String text) {
    return SliverToBoxAdapter(
      child: Center(
          child: Text(text)
      ),
    );
  }

  Widget buildRestaurantList(List<Order> orders) {
    return SliverPadding(
        padding: EdgeInsets.all(10),
        sliver: SliverList(
            delegate:SliverChildListDelegate(
              orders.map((order)=>OrderCard(order)).toList(),
            ),
        )
    );
  }

  Future<void> refreshList() async {
    var server = Head.of(context).userServer;
    var account = server.account;
    var newActiveOrders = <Order>[];
    var newPreviousOrders = <Order>[];

    for (var order in account.activeOrders) {
      var newOrder = (await server.getObjectByID<Order>(order.id!)) as Order;
      if (newOrder.isDelivered) {
        newPreviousOrders.add(newOrder);
      } else {
        newActiveOrders.add(newOrder);
      }
    }
    for (var order in account.previousOrders) {
      var newOrder = (await server.getObjectByID<Order>(order.id!)) as Order;
      if (newOrder.isDelivered) {
        newPreviousOrders.add(newOrder);
      } else {
        newActiveOrders.add(newOrder);
      }
    }
    account.activeOrders.clear();
    account.activeOrders.addAll(newActiveOrders);
    account.previousOrders.clear();
    account.previousOrders.addAll(newPreviousOrders);
    await account.justEditThis();
    setState(() {

    });
    return await Future.delayed(Duration(milliseconds: 200));
  }
}
