import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:user/order_card.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {


  @override
  Widget build(BuildContext context) {

    var activeOrders = (Head.of(context).server.account as UserAccount).activeOrders;
    var previousOrders = (Head.of(context).server.account as UserAccount).previousOrders;

    final headerStyle = Theme.of(context).textTheme.headline1!;

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
    var server = Head.of(context).server;
    var account = server.account as UserAccount;
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
