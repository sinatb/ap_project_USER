import 'package:flutter/material.dart';
import 'package:models/models.dart';

class RestaurantHeaderDelegate extends SliverPersistentHeaderDelegate {

  final Restaurant _restaurant;
  final TabBar _tabBar;
  final bool _isInArea;
  RestaurantHeaderDelegate(this._tabBar, this._restaurant, this._isInArea);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDataCard(context),
        Material(child: _tabBar),
      ],
    );
  }

  Widget buildDataCard(BuildContext context) {
    const headerVerticalGap = 13.0;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.location_on_outlined, color: Theme.of(context).colorScheme.secondaryVariant,),
              const SizedBox(width: 5,),
              Text(_restaurant.address.text),
              const SizedBox(width: 5,),
              buildArea(_isInArea, fontSize: 14),
            ],
          ),
          const SizedBox(height: headerVerticalGap,),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.restaurant_menu, color: Theme.of(context).colorScheme.secondaryVariant,),
              const SizedBox(width: 5,),
              Text(createCategoriesString()),
            ],
          ),
          const SizedBox(height: headerVerticalGap,),
          Wrap(
            spacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              buildScoreFill(_restaurant.score, iconSize: 18),
              buildCommentsCount(_restaurant.numberOfComments, iconSize: 18),
            ],
          ),
        ],
      ),
    );
  }

  String createCategoriesString() => _restaurant.foodCategories.map((e) => Strings.get(e.toString())).join(', ');

  @override
  double get maxExtent => _tabBar.preferredSize.height + 122;

  @override
  double get minExtent => _tabBar.preferredSize.height + 122;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}