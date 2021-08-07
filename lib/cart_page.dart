import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'cart_item_card.dart';
import 'profile_panel.dart';

class UserCart extends StatefulWidget {
  @override
  _UserCartState createState() => _UserCartState();
}

class _UserCartState extends State<UserCart> {

  @override
  Widget build(BuildContext context) {
    var cartList = Head.of(context).userServer.account.cart;
    return CustomScrollView(
      slivers: [
          SliverAppBar(
            floating: true,
            centerTitle: true,
            title: Text(Strings.get('cart-page-app-bar')!,style: Theme.of(context).textTheme.headline1),
            actions: [
              IconButton(icon: Icon(Icons.person,color: Theme.of(context).iconTheme.color,), onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UserAccountPage())
                );
              })
            ],
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
              o.map((e) => CartItem(e, ()=>setState((){}), key: UniqueKey(),)).toList(),
            ),
          ),
      );
    return SliverToBoxAdapter(
        child : Center(
          child : Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.5),
            child: Text(Strings.get('cart-page-no-items-in-cart')!, style: Theme.of(context).textTheme.bodyText2,),
          ),
        )
    );
  }
}
