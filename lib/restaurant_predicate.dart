import 'package:models/models.dart';

class RestaurantPredicate {
  String name = '';

  bool Function(Restaurant) generate() {

    return (Restaurant restaurant) {
      return restaurant.name.contains(RegExp(name, caseSensitive: false));
    };
  }
}