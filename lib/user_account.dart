import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:user/favourite_restaurants_page.dart';
import 'user_comments.dart';
import 'add_address.dart';

class UserAccountPage extends StatefulWidget {
  @override
  _UserAccountPageState createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  
  var _formKey = GlobalKey<FormState>();
  TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CommonColors.black);
  TextStyle otherStyle = TextStyle(fontSize: 15, color: CommonColors.black);
  late final UserAccount user;
  
  @override
  Widget build(BuildContext context) {
    user = (Head.of(context).server.account as UserAccount);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Text(Strings.get('user-account-app-bar')!),
      ),
      body: ListView(
        children: [
          buildAccountTile(),
          buildFundTile(),
          buildCommentsTile(),
          buildRestaurantsTile(),
          buildAddressesTile(),
        ],
      ),
    );
  }

  Widget buildAccountTile() {
    return ExpansionTile(
      title: Text(Strings.get('account-info-title')!),
      leading: Icon(Icons.person),
      children: [
        buildTextField(Strings.get('firstname')!, user.firstName),
        buildTextField(Strings.get('lastname')!, user.lastName),
        buildTextField(Strings.get('phone-number')!, Strings.censorPhoneNumber(user.phoneNumber)),
      ],
    );
  }

  Widget buildTextField(String label, String value) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
      ),
      enabled: false,
      readOnly: true,
      initialValue: value,
    );
  }

  Widget buildFundTile() {
    return ExpansionTile(
      title: Text(Strings.get('add-fund-hint')!),
      leading: Icon(Icons.attach_money_rounded),
      maintainState: true,
      children: [
        Text('Current credit : ' + user.credit.toString(), style: otherStyle,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: Strings.get('add-fund-hint'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return Strings.get('add-fund-null-error');
                    var intValue = int.tryParse(value);
                    if (intValue! <= 0)
                      return Strings.get('add-fund-negative-error');
                  },
                  onSaved: (value) => user.credit += Price(int.tryParse(value!)!),
                ),
              ),
            ),
            Flexible(
                child: buildModelButton('Add', CommonColors.green!, addPressed)
            ),
          ],
        ),
      ],
    );
    }

  void addPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(showBar(Strings.get('credit-added')!, Duration(milliseconds: 2000)));
    }
    _formKey.currentState!.reset();
    setState(() {});
  }

  Widget buildCommentsTile() {
    return GestureDetector(
      child: ExpansionTile(
        title: Text(Strings.get('my-comments-title')!),
        leading: Icon(Icons.comment),
      ),
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => UserCommentsPage())
        );
      },
    );
  }

  Widget buildRestaurantsTile() {
    return GestureDetector(
      child: ExpansionTile(
        title: Text(Strings.get('fav-restaurants-app-bar')!),
        leading: Icon(Icons.favorite_rounded),
      ),
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => FavouriteRestaurantsPage())
        );
      },
    );
  }

  Widget buildAddressesTile() {
    var cards = <Widget>[];
    user.addresses.forEach((key, value) => cards.add(buildAddressCard(key, value, key == user.defaultAddress)));
    return ExpansionTile(
      title: Text(Strings.get('addressed-title')!),
      leading: Icon(Icons.location_on_outlined),
      children: [
        Text(Strings.get('address-actions-hint')!),
        ...cards,
        // FloatingActionButton(onPressed: () async {
        //   var result = await Navigator.of(context).push(
        //       MaterialPageRoute(builder: (context) => AddAddressPage())
        //   );
        //   if (result == null) return;
        //   setState(() {
        //     user.addAddress(name, address);
        //   });
        // },),
      ],
    );
  }

  Widget buildAddressCard(String name, Address address, bool isDefault) {
    final shadows = [BoxShadow(blurRadius: 5, spreadRadius: 1, color: Theme.of(context).shadowColor.withOpacity(0.2))];
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: shadows,
      ),
      child: ListTile(
        title: Text(name),
        leading: isDefault ? Icon(Icons.check_circle) : null,
        subtitle: Text(address.text),
        isThreeLine: true,
        visualDensity: VisualDensity.comfortable,
        trailing: isDefault ? null : IconButton(icon: Icon(Icons.remove_circle_outline_rounded), onPressed: () {
          setState(() {
            user.removeAddress(name);
          });
        },),
        // set as default address
        onLongPress: isDefault ? null : () async {
          var result = await showDialog(context: context, builder: (context) => buildSetDefaultDialog());
          if (result == null || result == false) return;
          setState(() {
            user.defaultAddress = name;
          });
        },
        // edit address
        onTap: () async {
          var result = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddAddressPage())
          );
          if (result == null) return;
          setState(() {
            user.addAddress(name, result);
          });
        },
      ),
    );
  }

  Widget buildSetDefaultDialog() {
    return AlertDialog(
      actions: [
        TextButton(child: Text(Strings.get('set-default-address')!), onPressed: () {
          Navigator.of(context).pop(true);
        },
        ),
      ],
    );
  }
}
