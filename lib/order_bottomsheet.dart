import 'package:flutter/material.dart';
import 'package:models/models.dart';

class OrderFood extends StatefulWidget {
  final Food food;

  OrderFood(this.food) : super();

  @override
  _OrderFoodState createState() => _OrderFoodState();
}

class _OrderFoodState extends State<OrderFood> {
  TextStyle headerStyle = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: CommonColors.black);
  TextStyle otherStyle = TextStyle(fontSize: 15, color: CommonColors.black);
  var _formKey = GlobalKey<FormState>();
  int numberOfFoods = 0;

  @override
  Widget build(BuildContext context) {
    Size phoneSize = MediaQuery.of(context).size;
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Container(
                    width: phoneSize.width,
                    height: phoneSize.height / 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text(
                            widget.food.name,
                            style: headerStyle,
                          ),
                          Spacer(),
                          Text(
                            widget.food.price.toString(),
                            style: otherStyle,
                          )
                        ],
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        widget.food.description,
                        style: otherStyle,
                      )
                    ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: Strings.get('order-bottom-sheet-number'),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (String? num) {
                        if (num == null || num.isEmpty)
                          return Strings.get('order-bottom-sheet-empty-error');
                        var parsed = int.tryParse(num);
                        if (parsed == null || parsed <= 0)
                          return Strings.get('order-bottom-sheet-negative-error');
                      },
                      onSaved: (num) => numberOfFoods = int.tryParse(num!)!,
                    )
                  ),
                buildModelButton(
                    Strings.get('order-bottom-sheet-order')!, CommonColors.green!,
                    () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        Navigator.pop(context, {widget.food.toFoodData(): numberOfFoods});
                  }
                }
              )
            ],
          ),
        )));
  }
}
