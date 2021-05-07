import 'package:flutter/material.dart';
import 'package:models/models.dart';
class CartItem extends StatefulWidget {
  final Order order;
  final VoidCallback rebuildMenu;
  CartItem(this.order , this.rebuildMenu):super();
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
              onPressed: () async {
                var res = await showDialog(
                    context: context,
                    builder: (context)=>buildRemoveDialog()
                );
                if (!res) return;
                  setState(() {
                    widget.order.items.remove(o);
                  if (widget.order.items.isEmpty) {
                    (Head.of(context).server.account as UserAccount).cart.remove(widget.order);
                    widget.rebuildMenu();
                  }
                  });
              },
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
  buildRemoveDialog() {
    return AlertDialog(
      title: Text(Strings.get('food-remove-dialog-title')!),
      titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: CommonColors.black),
      content: SingleChildScrollView(
        child: Text(Strings.get('remove-food-dialog-message')!),
      ),
      contentTextStyle: TextStyle(fontSize: 15, color: CommonColors.black),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(Strings.get('food-remove-dialog-no')!),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(Strings.get('food-remove-dialog-yes')!),
        ),
      ],
    );
  }
}
