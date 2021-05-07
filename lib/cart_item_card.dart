import 'package:flutter/material.dart';
import 'package:models/models.dart';
class CartItem extends StatefulWidget {
  final Order order;
  CartItem(this.order):super();
  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CommonColors.black);
  TextStyle otherStyle = TextStyle(fontSize: 15, color: CommonColors.black);


  @override
  Widget build(BuildContext context) {
    return Card(
      child : ExpansionTile(
          title: Text(widget.order.restaurant.name , style:headerStyle,),
          subtitle:Text(widget.order.time.toString()),
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
            trailing: IconButton(
              icon: Icon(Icons.clear,color: CommonColors.red,),
              onPressed: (){},
            ),
          ),
        ),
    );
  }
  List<Widget> buildListOfWidget()
  {
    List<Widget> retValue = [];
    widget.order.items.forEach((key, value) {retValue.add(buildOrderItem(key, value));});
    print('$retValue');
    return retValue;
  }

}
