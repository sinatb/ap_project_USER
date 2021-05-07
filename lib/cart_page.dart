import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:user/cart_item_card.dart';

class UserCart extends StatefulWidget {
  @override
  _UserCartState createState() => _UserCartState();
}

class _UserCartState extends State<UserCart> {

  @override
  Widget build(BuildContext context) {
    var cartList = (Head.of(context).server.account as UserAccount).cart;
    return CustomScrollView(
      slivers: [
          SliverAppBar(
            floating: true,
            centerTitle: true,
            title: Text(Strings.get('cart-page-app-bar')!,style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold , color: CommonColors.black)),
          ),
          buildCartItems(cartList),
      ],
    );
  }
  Widget buildCartItems(List<Order> o )
  {

    if(o.isNotEmpty)
      return SliverPadding(
          padding: EdgeInsets.all(10),    
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              o.map((e) => CartItem(e,()=>setState((){}))).toList(),
            ),
          ),
      );
    return SliverToBoxAdapter(
        child : Center(
          child : Text(Strings.get('cart-page-no-items-in-cart')!,style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold , color: CommonColors.black),),
        )
    );
  }
}
