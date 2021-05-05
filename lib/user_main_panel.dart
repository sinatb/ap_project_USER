import 'package:flutter/material.dart';
import 'package:models/models.dart';
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
    return BottomNavigationBar(
        items:[

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined,color: CommonColors.black,),
            label: Strings.get('bottom-nav-cart'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined,color: CommonColors.black,),
            label: Strings.get('bottom-nav-restaurants'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined,color: CommonColors.black,),
            label: Strings.get('bottom-nav-orders'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin_outlined,color: CommonColors.black,),
            label: Strings.get('bottom-nav-user-account'),
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
    Center(child:Text('to be implemented')),
    RestaurantsPage(),
    Center(child:Text('to be implemented')),
    Center(child:Text('to be implemented')),
  ];

}