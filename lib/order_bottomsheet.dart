import 'package:flutter/material.dart';
import 'package:models/models.dart';

class OrderFood extends StatelessWidget {
  static int _numberOfFoods = 0;
  static final _formKey = GlobalKey<FormState>();

  final Food food;
  final int? previouslyAdded;
  OrderFood(this.food, this.previouslyAdded) : super();

  @override
  Widget build(BuildContext context) {

    Size phoneSize = MediaQuery.of(context).size;
    TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CommonColors.black);
    TextStyle otherStyle = TextStyle(fontSize: 15, color: CommonColors.black);

    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              width: phoneSize.width,
              height: phoneSize.height / 4,
              child : food.image,
            ),
            Divider(color: Colors.grey,),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(food.name, style: headerStyle,),
                  Text(food.price.toString(), style: otherStyle,)
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text('Description: ', style: otherStyle,),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(food.description, style: otherStyle,),
            ),
            if (food.isAvailable)
              Padding(
                  padding: EdgeInsets.all(10),
                  child: buildNumberField()
              ),
            if (food.isAvailable)
              Center(
                child: buildModelButton(Strings.get('order-bottom-sheet-order')!, CommonColors.green!, () => orderPressed(context)),
              ),
          ],
        )
    );
  }

  Widget buildNumberField() {
    return Form(
      key: _formKey,
      child: TextFormField(
        decoration: InputDecoration(
          hintText: Strings.get('order-bottom-sheet-number'),
        ),
        initialValue: previouslyAdded?.toString(),
        keyboardType: TextInputType.number,
        validator: (String? num) {

          //counts as zero
          if (num == null || num.isEmpty) {
            return null;
          }

          var parsed = int.tryParse(num);

          if (parsed == null) {
            return Strings.get('add-fund-invalid-number');
          }

          if (parsed < 0) {
            return Strings.get('order-bottom-sheet-negative-error');
          }
        },
        onSaved: (num) {
          if (num == null || num.isEmpty) {
            _numberOfFoods = 0;
            return;
          }
          _numberOfFoods = int.parse(num);
        }
      ),
    );
  }
  orderPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.pop(context, MapEntry(food.toFoodData(), _numberOfFoods));
    }
  }
}
