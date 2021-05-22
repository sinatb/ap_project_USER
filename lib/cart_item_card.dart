import 'package:flutter/material.dart';
import 'package:models/models.dart';
class CartItem extends StatefulWidget {
  final Order order;
  final VoidCallback rebuildMenu;
  CartItem(this.order , this.rebuildMenu) : super();

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
          subtitle: Wrap(
            direction: Axis.vertical,
            spacing: 5,
            children: [
              Text(Strings.formatDate(widget.order.time), style: Theme.of(context).textTheme.caption),
              Text(widget.order.customer.address.text, style: Theme.of(context).textTheme.caption),
            ],
          ),
          trailing: Text(widget.order.totalCost.toString()),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ...buildListOfItems(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildModelButton(Strings.get('cart-page-proceed')!, CommonColors.green!, proceedPressed),
                buildModelButton(Strings.get('cart-page-delete')!, CommonColors.red!, deletePressed)
              ],
            )
          ],
      )
    );
  }

  List<Widget> buildListOfItems() {
    List<Widget> retValue = [];
    widget.order.items.forEach((key, value) {retValue.add(buildOrderItem(key, value));});
    print('$retValue');
    return retValue;
  }

  Widget buildOrderItem(FoodData data , int count) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        child: ListTile(
          title: Text(data.name , style: headerStyle,),
          subtitle: Text('${data.price} × $count = ${data.price.toInt() * count}' , style: otherStyle,),
          trailing: IconButton(
            icon: Icon(Icons.remove_circle_rounded, color: CommonColors.red,),
            onPressed: () async {
              var res = await showDialog(
                  context: context,
                  builder: (context)=>buildRemoveDialog()
              );
              if (!res) return;
              setState(() {
                widget.order.items.remove(data);
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

  void proceedPressed(){

    var server = Head.of(context).server;
    var user = server.account as UserAccount;
    if (!server.isInArea(user.defaultAddress!, widget.order.restaurant.address, widget.order.restaurant.areaOfDispatch)) {
      showDialog(context: context, builder: (context) => buildOutsideAreaDialog());
      return;
    }

    if (widget.order.totalCost.toInt() > user.credit.toInt()) {
      showDialog(context: context, builder: (context) => buildInsufficientFundDialog());
      return;
    }
    widget.order.customer = user.toCustomerData(user.defaultAddress!);
    widget.order.sendRequest();
    user.activeOrders.add(widget.order);
    user.cart.remove(widget.order);
    user.credit -= widget.order.totalCost;
    widget.rebuildMenu();
    ScaffoldMessenger.of(context).showSnackBar(
      showBar(Strings.get('order-completed')!, Duration(milliseconds: 2000),),
    );
  }

  void deletePressed() async {
    var result = await showDialog(
        context: context,
        builder: (context) => buildRemoveDialog()
    );

    if (result == null || result == false) return;

    (Head.of(context).server.account as UserAccount).cart.remove(widget.order);
    widget.rebuildMenu();
    ScaffoldMessenger.of(context).showSnackBar(
        showBar(Strings.get('delete_order')!, Duration(milliseconds: 2000))
    );
  }

  buildRemoveDialog() {
    return AlertDialog(
      title: Text(Strings.get('food-remove-dialog-title')!),
      titleTextStyle: headerStyle,
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

  buildInsufficientFundDialog() {

    var user = (Head.of(context).server.account as UserAccount);
    var _formKey = GlobalKey<FormState>();

    return AlertDialog(
      title: Text(Strings.get('insufficient-fund-dialog')!),
      content: Text('${Strings.get('current-credit-message')} ${user.credit} ${Strings.get('toman')}.'),
      titleTextStyle: headerStyle,
      actions: [
        Form(
          key: _formKey,
          child : Container(
            width: 300,
            height: 50,
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return Strings.get('add-fund-null-error');
                }
                var intValue = int.tryParse(value);
                if (intValue == null) {
                  return Strings.get('add-fund-invalid-number');
                }
                if (intValue <= 0) {
                  return Strings.get('add-fund-negative-error');
                }
              },
              onSaved: (value) => user.credit += Price(int.tryParse(value!)!),
              decoration: InputDecoration(
                hintText: Strings.get('add-fund-hint'),
              ),
            ),
          ),
        ),
        TextButton(
            onPressed: (){
              if (!_formKey.currentState!.validate()) return;
              _formKey.currentState!.save();
              Navigator.of(context).pop();
            },
            child: Text(Strings.get('fund-dialog-add-fund')!, style: otherStyle,)
        ),
      ],
    );
  }

  buildOutsideAreaDialog() {
    return AlertDialog(
      title: Text(Strings.get('outside-area-dialog-title')!),
      content: Text(Strings.get('outside-area-dialog-message')!),
      actions: [
        TextButton(child: Text(Strings.get('ok')!), onPressed: () => Navigator.of(context).pop()),
      ],
    );
  }
}
