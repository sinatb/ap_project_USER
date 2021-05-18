import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'restaurant_predicate.dart';

class SearchSheet extends StatelessWidget {

  static final _formKey = GlobalKey<FormState>();
  final _predicate = RestaurantPredicate();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: Strings.get('restaurant-name-hint'),
                icon: Icon(Icons.restaurant),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return Strings.get('search-name-empty');
                }
              },
              onSaved: (value) {
                _predicate.name = value ?? '';
              },
            ),
            SizedBox(height: 15,),
            buildModelButton(Strings.get('app-bar-leading-search')!, Theme.of(context).buttonColor, () => searchPressed(context))
          ],
        ),
      ),
    );
  }

  void searchPressed(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    Navigator.of(context).pop(_predicate.generate());
  }
}
