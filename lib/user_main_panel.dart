import 'package:flutter/material.dart';
import 'package:models/models.dart';


class MainPanel extends StatefulWidget {
  @override
  _MainPanelState createState() => _MainPanelState();
}

class _MainPanelState extends State<MainPanel> {
  var _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
  Widget buildBottomNavigationBar()
  {
    return BottomNavigationBar(
        items:[
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: Strings.get('bottom-nav-restaurants'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: Strings.get('bottom-nav-cart'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: Strings.get('bottom-nav-user-account'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_sharp),
            label: Strings.get('bottom-nav-orders'),
          ),

        ]
    );
  }

  var _pages = <Widget>[
    Text('to be implemented'),
    Text('to be implemented'),
    Text('to be implemented'),
    Text('to be implemented'),
  ];

}
