import 'package:flutter/material.dart';
import 'package:models/models.dart';

class DiscountDialog extends StatefulWidget {
  const DiscountDialog({Key? key, this.previousValue}) : super(key: key);
  final Discount? previousValue;

  @override
  _DiscountDialogState createState() => _DiscountDialogState();
}

class _DiscountDialogState extends State<DiscountDialog> {

  final _controller = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.previousValue != null) {
      _controller.text = widget.previousValue!.code;
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Strings.get('discount-dialog-title')!),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: Strings.get('discount-input-hint'),
          errorText: _error,
        ),
      ),
      actions: [
        TextButton(child: Text(Strings.get('apply')!), onPressed: () async {
          if (_controller.text.isEmpty) {
            Navigator.of(context).pop(null);
            return;
          }
          var result = await Head.of(context).userServer.validateDiscount(_controller.text);
          if (result == null) {
            setState(() {
              _error = Strings.get('discount-invalid-code');
            });
            return;
          }
          Navigator.of(context).pop(result);
        }),
      ],
    );
  }
}
