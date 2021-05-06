import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:user/order_bottomsheet.dart';
class FoodCard extends StatefulWidget {
  final Food food;
  Map<FoodData,int> ordered;
  final VoidCallback restaurantPageState;

  FoodCard(this.food ,this.ordered,this.restaurantPageState) : super();
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
              onPressed: () async
              {
                widget.ordered.addAll(await showModalBottomSheet(
                    context: context,
                    isDismissible: false,
                    builder: (context)=>OrderFood(widget.food)
                ));
                print(widget.ordered.toString() );
              },
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
