import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'cart_page.dart';
import 'order_page.dart';
import 'restaurants_page.dart';

class MainPanel extends StatefulWidget {
  @override
  _MainPanelState createState() => _MainPanelState();
}

class _MainPanelState extends State<MainPanel> {
  var _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildBottomNavigationBar()
  {
    var black = Theme.of(context).colorScheme.onBackground;
    return BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined,color: black,),
            label: Strings.get('bottom-nav-cart'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined,color: black,),
            label: Strings.get('bottom-nav-restaurants'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined,color: black,),
            label: Strings.get('bottom-nav-orders'),
          ),
        ],
        currentIndex:_currentIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
    );
  }

  var _pages = <Widget>[
    UserCart(),
    RestaurantsPage(),
    OrdersPage(),
  ];

}
