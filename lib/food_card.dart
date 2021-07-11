import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'order_bottomsheet.dart';

class FoodCard extends StatelessWidget {

  final Food food;
  final Map<FoodData,int> orderedItems;

  FoodCard(this.food ,this.orderedItems) : super();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Flexible(
            child: Container(
              child: food.image,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            flex: 5,
            fit: FlexFit.tight,
          ),
          Flexible(
            child: ListTile(
              title: Text(food.name),
              trailing: buildAvailableIcon(food.isAvailable),
              subtitle: Text('${food.price} ${Strings.get('toman')}'),
            ),
            flex: 2,
            fit: FlexFit.tight,
          ),
          Flexible(
            child: TextButton(
              child: Text(Strings.get('restaurant-page-button')!),
              onPressed: () async {
                orderedItems.addAll(await showModalBottomSheet(
                    context: context,
                    builder: (context) => OrderFood(food)
                ));
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
