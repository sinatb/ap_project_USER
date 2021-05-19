import 'package:flutter/material.dart';
import 'package:models/models.dart';

class RestaurantHeaderDelegate extends SliverPersistentHeaderDelegate {

  final Restaurant _restaurant;
  final TabBar _tabBar;
  RestaurantHeaderDelegate(this._tabBar, this._restaurant);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(child: _tabBar),
      ],
    );
  }

  Widget buildDataCard(BuildContext context, Restaurant r) {
    return Row(
      children: [
        Container(
          width: 75,
          height: 75,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        ),
        Text(
          r.name,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CommonColors.black),
        ),
        Column(
            children: [
              Icon(
                Icons.star_border,
                color: CommonColors.black,
              ),
              Text(r.score.ceil().toString())
            ]
        ),
      ],
    );
  }

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

}