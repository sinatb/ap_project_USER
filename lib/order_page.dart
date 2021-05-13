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
    TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CommonColors.black);
    TextStyle otherStyle = TextStyle(fontSize: 15, color: CommonColors.black);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          centerTitle: true,
          title: Text(Strings.get('orders-app-bar')!),
        ),
        buildHeader(Strings.get('orders-active-orders-heading')!,),
        ((activeOrders.length>0)?buildRestaurantList(activeOrders, true) : SliverToBoxAdapter(child:Center(child:Text(Strings.get('orders-no-active-orders')! , style: headerStyle))))!,
        buildHeader(Strings.get('orders-previous-orders-heading')!,),
        ((previousOrders.length>0)?buildRestaurantList(previousOrders, true) : SliverToBoxAdapter(child:Center(child:Text(Strings.get('orders-no-previous-orders')! , style: headerStyle))))!,
      ],
    );
  }
  Widget? buildRestaurantList(List<Order> orders , bool canComment)
  {
    return SliverPadding(
        padding: EdgeInsets.all(10),
        sliver: SliverList(
            delegate:SliverChildListDelegate(
              orders.map((order)=>OrderCard(order,canComment)).toList(),
            )
        )
    );
  }
}
