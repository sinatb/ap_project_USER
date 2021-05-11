import 'package:flutter/material.dart';
import 'package:models/models.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  final bool canComment;
  OrderCard(this.order , this.canComment):super();
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
}
