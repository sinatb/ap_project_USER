import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'add_comment.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  final bool canCommentReOrder;
  OrderCard(this.order , this.canCommentReOrder):super();
  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CommonColors.black);
  TextStyle otherStyle = TextStyle(fontSize: 15, color: CommonColors.black);

  @override
  Widget build(BuildContext context) {
    return Card(
      child : ExpansionTile(
        title: Text(widget.order.restaurant.name , style:headerStyle,),
        subtitle:Text(Strings.formatDate(widget.order.time)),
        trailing:Text(widget.order.totalCost.toString()),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...buildListOfWidget(),
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
              widget.canCommentReOrder ? buildModelButton(Strings.get('orders-reorder-button')!, CommonColors.green! , reorderPressed)
                  : SizedBox(height: 10,),
              widget.canCommentReOrder ? buildModelButton(Strings.get('orders-comment-button')!, CommonColors.green! , showCommentBottomSheet)
                  : SizedBox(height: 10,),
           ],
          )
        ],
      )
    );
  }
  Widget buildOrderItem(FoodData o , int i)
  {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        child: ListTile(
          title: Text(o.name , style:headerStyle,),
          subtitle: Text(o.price.toString() + ' X ' + i.toString() + ' = '+(o.price*Price(i)).toString() , style: otherStyle,),
          ),
        ),
      );
  }
  List<Widget> buildListOfWidget()
  {
    List<Widget> retValue = [];
    widget.order.items.forEach((key, value) {retValue.add(buildOrderItem(key, value));});
    return retValue;
  }

  void showCommentBottomSheet() async {
    var result = await showModalBottomSheet(context: context, builder: (context) => CommentBottomSheet());
    if (result == null) return;
    var server = Head.of(context).server;
    var newComment = Comment(
        server: server,
        restaurantID: widget.order.restaurant.id!,
        score: result['score'].toInt(),
        title: result['title'],
        message: result['message'],
    );
    newComment.serialize(server.serializer);
    (server.account as UserAccount).commentIDs.add(newComment.id!);
    server.addNewComment(newComment);
  }


  void reorderPressed() {
    var newOrder = widget.order.reorder();
    if (newOrder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Strings.get('reorder-fail')!)),
      );
      return;
    }
    (Head.of(context).server.account as UserAccount).cart.add(newOrder);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(Strings.get('reorder-success')!)),
    );
  }
}
