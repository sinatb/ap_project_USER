import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'add_comment.dart';

class OrderCard extends StatelessWidget {

  final Order order;
  OrderCard(this.order) : super();

  @override
  Widget build(BuildContext context) {

    return Card(
        child : ExpansionTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text(order.restaurant.name , style: Theme.of(context).textTheme.headline5,),
          ),
          subtitle: Wrap(
            direction: Axis.vertical,
            spacing: 5,
            children: [
              Text(Strings.formatDate(order.time), style: Theme.of(context).textTheme.caption),
              Text(order.customer.address.text, style: Theme.of(context).textTheme.caption),
            ],
          ),
          maintainState: true,
          trailing: Text(order.totalCost.toString()),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(order.code),
            ),
            ...buildListOfItems(context),
            if (order.isDelivered)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildModelButton(Strings.get('orders-comment-button')!, Theme.of(context).buttonColor, () => showCommentBottomSheet(context)),
                    buildModelButton(Strings.get('orders-reorder-button')!, Theme.of(context).accentColor, () => reorderPressed(context)),
                  ],
                ),
              ),
          ],
          childrenPadding: const EdgeInsets.all(10),
        )
    );
  }

  List<Widget> buildListOfItems(BuildContext context) {
    List<Widget> retValue = [];
    order.items.forEach((key, value) => retValue.add(buildOrderItem(key, value, context)));
    return retValue;
  }

  Widget buildOrderItem(FoodData data , int count, BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(data.name , style: Theme.of(context).textTheme.headline5,),
        subtitle: Text('${data.price} × $count = ${data.price.toInt() * count}'),
        ),
      );
  }

  void showCommentBottomSheet(BuildContext context) async {
    var result = await showModalBottomSheet(context: context, builder: (context) => CommentBottomSheet());
    if (result == null) return;
    var server = Head.of(context).userServer;
    var newComment = Comment(
        server: server,
        restaurantID: order.restaurant.id!,
        score: result['score'].toInt(),
        title: result['title'],
        message: result['message'],
    );
    server.addNewComment(newComment);
  }

  void reorderPressed(BuildContext context) async {
    var newOrder = await order.reorder();
    if (newOrder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        showBar(Strings.get('reorder-fail')!,Duration(milliseconds: 2000))
      );
      return;
    }
    Head.of(context).userServer.account.addToCart(newOrder);
    ScaffoldMessenger.of(context).showSnackBar(
      showBar(Strings.get('reorder-success')!,Duration(milliseconds: 2000)),
    );
  }
}
