import 'package:flutter/material.dart';
import 'package:models/models.dart';
class FoodCard extends StatefulWidget {
  final Food food;
  final VoidCallback restaurantPageState;

  FoodCard(this.food , this.restaurantPageState) : super();
  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            flex: 5,
            fit: FlexFit.tight,
          ),
          Flexible(
            child: ListTile(
              title: Text(widget.food.name),
              trailing: buildAvailableIcon(widget.food.isAvailable),
              subtitle: Text('${widget.food.price} ${Strings.get('toman')}'),
            ),
            flex: 2,
            fit: FlexFit.tight,
          ),
          Flexible(
            child: TextButton(
              child: Text(Strings.get('restaurant-page-button')!),
              onPressed: () {},
            ),
            flex: 1,
            fit: FlexFit.tight,
          ),
        ],
      ),
    );
  }

  Widget buildAvailableIcon(isAvailable) {
    if (isAvailable) {
      return Icon(Icons.check_circle, color: Colors.green,);
    }
    return Icon(Icons.highlight_remove_rounded, color: Colors.red,);
  }
}
