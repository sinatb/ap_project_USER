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
  late UserAccount user;
  
  @override
  Widget build(BuildContext context) {
    user = Head.of(context).server.account as UserAccount;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Text(Strings.get('user-account-app-bar')!,style: Theme.of(context).textTheme.headline1,),
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
                    if (value == null || value.isEmpty) {
                      return Strings.get('add-fund-null-error');
                    }

                    var parsed = int.tryParse(value);
                    if (parsed == null) {
                      return Strings.get('add-fund-invalid-number');
                    }

                    if (parsed <= 0) {
                      return Strings.get('add-fund-negative-error');
                    }
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
        SizedBox(height: 15,),
      ],
    );
    }

  void addPressed() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    ScaffoldMessenger.of(context).showSnackBar(showBar(Strings.get('credit-added')!, Duration(milliseconds: 2000)));
    _formKey.currentState!.reset();
    setState(() {});
  }

  Widget buildCommentsTile() {
    return ExpansionTile(
      key: GlobalKey(),
      title: Text(Strings.get('my-comments-title')!),
      leading: Icon(Icons.comment),
      onExpansionChanged: (isOpen) {
        if (isOpen) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => UserCommentsPage())
          );
          setState(() {});
        }
      },
    );
  }

  Widget buildRestaurantsTile() {
    return ExpansionTile(
      key: GlobalKey(),
      title: Text(Strings.get('fav-restaurants-app-bar')!),
      leading: Icon(Icons.favorite_rounded),
      onExpansionChanged: (isOpen) {
        if (isOpen) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => FavouriteRestaurantsPage())
          );
          setState(() {});
        }
      },
    );
  }

  Widget buildAddressesTile() {
    var cards = <Widget>[];
    user.addresses.forEach((e) => cards.add(buildAddressCard(e, e.name == user.defaultAddressName)));
    return ExpansionTile(
      title: Text(Strings.get('addressed-title')!),
      leading: Icon(Icons.location_on_outlined),
      expandedCrossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(child: Text(Strings.get('address-actions-hint')!)),
        ),
        ...cards,
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: FloatingActionButton(child: Icon(Icons.add), onPressed: () async {
            var result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddAddressPage())
            );
            if (result == null) return;
            setState(() {
              user.addAddress(result);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              showBar(Strings.get('address-added')!,Duration(milliseconds: 2000)),
            );
          },),
        ),
      ],
    );
  }

  Widget buildAddressCard(Address address, bool isDefault) {
    final shadows = [BoxShadow(blurRadius: 5, spreadRadius: 1, color: Theme.of(context).shadowColor.withOpacity(0.2))];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: shadows,
      ),
      child: ListTile(
        title: Text(address.name),
        leading: Opacity(child: Icon(Icons.check_circle, color: Colors.green,), opacity: isDefault ? 1 : 0,),
        subtitle: Text(address.text),
        visualDensity: VisualDensity.comfortable,
        trailing: isDefault ? null : IconButton(icon: Icon(Icons.remove_circle_outline_rounded, color: Colors.red,), onPressed: () {
          setState(() {
            user.removeAddress(address);
          });
        },),
        // set as default address
        onLongPress: isDefault ? null : () async {
          var result = await showDialog(context: context, builder: (context) => buildSetDefaultDialog());
          if (result == null || result == false) return;
          setState(() {
            user.defaultAddressName = address.name;
          });
        },
        // edit address
        onTap: () async {
          bool? result = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddAddressPage(address))
          );
          if (result == null || result == false) return;
          setState(() {
            if (isDefault) {
              user.defaultAddressName = address.name;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            showBar(Strings.get('address-edited')!,Duration(milliseconds: 2000)),
          );
        },
      ),
    );
  }

  Widget buildSetDefaultDialog() {
    return AlertDialog(
      actions: [
        TextButton(child: Text(Strings.get('set-default-address')!, style: Theme.of(context).textTheme.subtitle1,), onPressed: () {
          Navigator.of(context).pop(true);
        },
        ),
      ],
    );
  }
}
