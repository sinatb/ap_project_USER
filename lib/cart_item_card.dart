import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'discount_dialog.dart';

class CartItem extends StatefulWidget {
  final Order order;
  final VoidCallback rebuildMenu;
  CartItem(this.order , this.rebuildMenu, {Key? key}) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {

  late TextStyle? headerStyle;
  late TextStyle? otherStyle;
  Discount? _discount;

  @override
  Widget build(BuildContext context) {
    headerStyle = Theme.of(context).textTheme.headline5;
    otherStyle = Theme.of(context).textTheme.bodyText1;

    return Card(
      child : ExpansionTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text(widget.order.restaurant.name , style: headerStyle,),
          ),
          subtitle: Wrap(
            direction: Axis.vertical,
            spacing: 5,
            children: [
              Text(Strings.formatDate(widget.order.time), style: Theme.of(context).textTheme.caption),
              Text(widget.order.customer.address.text, style: Theme.of(context).textTheme.caption),
            ],
          ),
          trailing: buildTotalCost(),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ...buildListOfItems(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: deletePressed, child: Text(Strings.get('cart-page-delete')!, style: TextStyle(color: Theme.of(context).errorColor),)),
                TextButton(onPressed: discountPressed, child: Text(Strings.get('discount-button')!)),
                TextButton(onPressed: proceedPressed, child: Text(Strings.get('cart-page-proceed')!)),
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
          subtitle: Text('${data.price} × $count = ${data.price.toInt() * count}' ,),
          trailing: IconButton(
            icon: Icon(Icons.remove_circle_rounded, color: Theme.of(context).colorScheme.error,),
            onPressed: () async {
              var res = await showDialog(
                  context: context,
                  builder: (context) => buildRemoveDialog()
              );
              if (!res) return;
              setState(() {
                widget.order.items.remove(data);
                if (widget.order.items.isEmpty) {
                  Head.of(context).userServer.account.removeFromCart(widget.order);
                  widget.rebuildMenu();
                }
              });
            },
          ),
        ),
      ),
    );
  }

  Price calculateTotalPrice(Price total) {
    if (_discount == null) {
      return total;
    }
    return total.apply(_discount!);
  }

  void proceedPressed() async {

    var server = Head.of(context).userServer;
    var user = server.account;
    if (!server.isInArea(user.defaultAddress!, widget.order.restaurant.address, widget.order.restaurant.areaOfDispatch)) {
      showDialog(context: context, builder: (context) => buildOutsideAreaDialog());
      return;
    }

    if (calculateTotalPrice(widget.order.totalCost).toInt() > user.credit.toInt()) {
      showDialog(context: context, builder: (context) => buildInsufficientFundDialog());
      return;
    }
    widget.order.customer = user.toCustomerData(user.defaultAddress!);
    await widget.order.sendRequest(calculateTotalPrice(widget.order.totalCost));
    if (_discount != null) {
      await server.useDiscount(_discount!);
    }
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

    Head.of(context).userServer.account.removeFromCart(widget.order);
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

    var user = Head.of(context).userServer.account;
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

  Widget buildTotalCost() {
    if (_discount == null) {
      return Text(widget.order.totalCost.toString());
    }
    return Text('${_discount!.percent}% ${widget.order.totalCost.apply(_discount!)}');
  }

  void discountPressed() async {
    _discount = await showDialog(context: context, builder: (context) => DiscountDialog(previousValue: _discount), barrierDismissible: false);
      setState(() {});
  }

}
