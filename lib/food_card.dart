import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'order_bottomsheet.dart';

class FoodCard extends StatelessWidget {

  final Food food;
  final Map<FoodData,int> orderedItems;

  FoodCard(this.food ,this.orderedItems) : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await buttonPressed(context);
      },
      child: Card(
        child: Column(
          children: [
            Flexible(
              child: Container(
                child: Image.asset('assets/default_food.jpg' , package: 'models',),
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
                trailing: buildAvailableIcon(food.isAvailable, context),
                subtitle: Text('${food.price} ${Strings.get('toman')}'),
              ),
              flex: 2,
              fit: FlexFit.tight,
            ),
            Flexible(
              child: TextButton(
                child: Text(Strings.get('restaurant-page-button')!),
                onPressed: () async {
                  await buttonPressed(context);
                },
              ),
              flex: 1,
              fit: FlexFit.tight,
            ),
          ],
        ),
      ),
    );
  }
  Widget buildAvailableIcon(isAvailable, BuildContext context) {
    if (isAvailable) {
      return Icon(Icons.check_circle, color: CommonColors.themeColorGreen,);
    }
    return Icon(Icons.highlight_remove_rounded, color: Theme.of(context).errorColor,);
  }

  Future<void> buttonPressed(BuildContext context) async {
    var result = await showModalBottomSheet<MapEntry<FoodData, int>>(
        context: context,
        builder: (context) => OrderFood(food, orderedItems[food.toFoodData()])
    );
    if (result == null) return;
    if (result.value == 0) {
      orderedItems.remove(result.key);
      return;
    }
    orderedItems[result.key] = result.value;
  }
}
