import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'map_page.dart';

class AddAddressPage extends StatefulWidget {
  // if non null, this page serves as editor
  final Address? address;

  AddAddressPage([this.address]) : super();

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {

  var _formKey = GlobalKey<FormState>();
  var _name = '';
  var _text = '';
  var _latitude = 0.0;
  var _longitude = 0.0;
  TextEditingController? _controller;
  
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }
  
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.get(widget.address == null ? 'add-address-title' : 'edit-address-title')!),
        elevation: 1,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: LimitedBox(
            maxHeight: MediaQuery.of(context).size.height/2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: Strings.get('address-name-hint'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Strings.get('empty-address-name');
                    }
                  },
                  onSaved: (value) => _name = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: Strings.get('address-text-hint'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Strings.get('empty-address-text');
                    }
                  },
                  onSaved: (value) => _text = value!,
                ),
                TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    icon: Icon(Icons.location_on),
                    hintText: Strings.get('address-coordinates-hint'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Strings.get('empty-address-coordinates');
                    }
                  },
                  onTap: setLatLng,
                  readOnly: true,
                ),
                buildModelButton(Strings.get('done')!, Theme.of(context).accentColor, donePressed)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setLatLng() async {
  }

  void donePressed() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    if (widget.address == null) {
      return Navigator.of(context).pop(Address(name: _name, text: _text, latitude: _latitude, longitude: _longitude));
    }
    widget.address!.name = _name;
    widget.address!.text = _text;
    widget.address!.latitude = _latitude;
    widget.address!.longitude = _longitude;
    Navigator.of(context).pop(true);
  }
}
