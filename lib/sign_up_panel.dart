import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'add_address.dart';
import 'user_main_panel.dart';

class SignUpPanel extends StatefulWidget {
  const SignUpPanel({Key? key}) : super(key: key);

  @override
  _SignUpPanelState createState() => _SignUpPanelState();
}

class _SignUpPanelState extends State<SignUpPanel> {

  late Server server;
  String? phoneNumber;
  String? password;
  String? firstName;
  String? lastName;
  Address? address;
  var _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;
  var _duplicateNumber = false;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    server = Head.of(context).server;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/login_background.jpg', package: 'models'), fit: BoxFit.cover),
        ),
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).cardColor,
          ),
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(Strings.get('sign-up-header')!, style: Theme.of(context).textTheme.headline6,),
                  const SizedBox(height: 10,),
                  if (_duplicateNumber)
                    buildDuplicateNumberError(),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: Strings.get('first-name-hint'),
                      icon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Strings.get('empty-first-name');
                      }
                    },
                    onSaved: (value) => firstName = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: Strings.get('last-name-hint'),
                      icon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Strings.get('empty-last-name');
                      }
                    },
                    onSaved: (value) => lastName = value,
                  ),
                  buildLoginPhoneNumberField(server, (value) => phoneNumber = value),
                  PasswordField(server, (value) => password = value),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: Strings.get('signup-address-hint'),
                      icon: Icon(Icons.location_on_outlined)
                    ),
                    controller: _controller,
                    readOnly: true,
                    onTap: addressFieldPressed,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Strings.get('address-text-empty');
                      }
                    },
                  ),
                  buildModelButton(Strings.get('sign-up-button')!, Theme.of(context).accentColor, signUpPressed),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(Strings.get('login-prompt')!),
                      TextButton(child: Text(Strings.get('login-button')!), onPressed: loginPressed,)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDuplicateNumberError() {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).errorColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).errorColor),
      ),
      child: Text(Strings.get('duplicate-number-error')!, style: TextStyle(color: Theme.of(context).iconTheme.color),),
    );
  }

  void addressFieldPressed() async {
    var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddAddressPage()));
    if (result == null) return;
    setState(() {
      address = result;
      _controller.text = '${address?.text} (${address?.latitude.toStringAsFixed(2)}, ${address?.longitude.toStringAsFixed(2)})';
    });
  }

  void signUpPressed() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    server.signUpUser(firstName!, lastName!, phoneNumber!, password!, address!);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainPanel()));
  }

  void loginPressed() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPanel(isForUser: true, nextPageBuilder: (context) => MainPanel())));
  }
}
