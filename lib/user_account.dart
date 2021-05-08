import 'package:flutter/material.dart';
import 'package:models/models.dart';

class UserAccountPage extends StatefulWidget {
  @override
  _UserAccountPageState createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  var _formKey = GlobalKey<FormState>();
  TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CommonColors.black);
  TextStyle otherStyle = TextStyle(fontSize: 15, color: CommonColors.black);
  @override
  Widget build(BuildContext context) {
    var user = (Head.of(context).server.account as UserAccount);


    return CustomScrollView(
        slivers:[
            SliverAppBar(
              centerTitle: true,
              title: Text(Strings.get('user-account-app-bar')!,style: headerStyle,),
            ),
            buildHeader('User Credit', CommonColors.black, 18),
            buildFundCard(user),
            buildHeader('User Comments', CommonColors.black, 18),
            buildHeader('Favourite Restaurants', CommonColors.black, 18)
        ]
      );
  }

  Widget buildFundCard(UserAccount user) {
    return SliverToBoxAdapter(child:Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
              Flexible(child:
                Text(
                 'Current credit : '+user.credit.toInt().toString(),
                  style: otherStyle,
                )
              ),
              Flexible(child:
                Form(
                    key: _formKey,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return Strings.get('add-fund-null-error');
                        var intValue = int.tryParse(value);
                        if (intValue! <= 0)
                          return Strings.get('add-fund-negative-error');
                      },
                      onSaved: (value) => user.credit += Price(int.tryParse(value!)!),
                      decoration: InputDecoration(
                        hintText: Strings.get('add-fund-hint'),
                      ),
                    )
                )
              ),
              Flexible(child:
                buildModelButton('Add', CommonColors.green!, () {
                  if (_formKey.currentState!.validate())
                    _formKey.currentState!.save();
                  _formKey.currentState!.reset();
                  setState(() {});
                }
                )
              )
          ],
        ),
      ));
    }
  Widget buildHeader(String title, Color textColor, double fontSize) {
    return SliverPadding(
      padding: EdgeInsets.all(10),
      sliver: SliverToBoxAdapter(
          child: Column(
            children: [
              Text(title, style: TextStyle(color: textColor, fontSize: fontSize,),),
              Divider(thickness: 2,),
            ],
          )
      ),
    );
  }



}