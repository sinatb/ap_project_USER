import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'add_comment.dart';

class OrderCard extends StatelessWidget {

  final Order order;
  OrderCard(this.order) : super();

  final headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CommonColors.black);
  final otherStyle = TextStyle(fontSize: 15, color: CommonColors.black);

  @override
  Widget build(BuildContext context) {

    return Card(
        child : ExpansionTile(
          title: Text(order.restaurant.name , style:headerStyle,),
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
            ...buildListOfItems(),
            if (order.isDelivered)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildModelButton(Strings.get('orders-reorder-button')!, CommonColors.green! , () => reorderPressed(context)),
                  buildModelButton(Strings.get('orders-comment-button')!, CommonColors.green! , () => showCommentBottomSheet(context))
                ],
              ),
          ],
          childrenPadding: const EdgeInsets.all(10),
        )
    );
  }

  List<Widget> buildListOfItems() {
    List<Widget> retValue = [];
    order.items.forEach((key, value) => retValue.add(buildOrderItem(key, value)));
    return retValue;
  }

  Widget buildOrderItem(FoodData data , int count) {
    return Card(
      child: ListTile(
        title: Text(data.name , style: headerStyle,),
        subtitle: Text('${data.price} × $count = ${data.price.toInt() * count}' , style: otherStyle,),
        ),
      );
  }

  void showCommentBottomSheet(BuildContext context) async {
    var result = await showModalBottomSheet(context: context, builder: (context) => CommentBottomSheet());
    if (result == null) return;
    var server = Head.of(context).server;
    var newComment = Comment(
        server: server,
        restaurantID: order.restaurant.id!,
        score: result['score'].toInt(),
        title: result['title'],
        message: result['message'],
    );
    //newComment.serialize(server.serializer);
    //the line under add new comment used to be here but now its under add new comment because add new comment automatically serializes the obj
    server.addNewComment(newComment);
    (server.account as UserAccount).commentIDs.add(newComment.id!);
  }

  void reorderPressed(BuildContext context) async {
    var newOrder = await order.reorder();
    if (newOrder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        showBar(Strings.get('reorder-fail')!,Duration(milliseconds: 2000))
      );
      return;
    }
    (Head.of(context).server.account as UserAccount).cart.add(newOrder);
    ScaffoldMessenger.of(context).showSnackBar(
      showBar(Strings.get('reorder-success')!,Duration(milliseconds: 2000)),
    );
  }
}
