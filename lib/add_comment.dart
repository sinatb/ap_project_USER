import 'package:flutter/material.dart';
import 'package:models/models.dart';
class CommentBottomSheet extends StatefulWidget {

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {

  var _formKey = GlobalKey<FormState>();
  String _title = '';
  String _message = '';
  double _score = 3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: Strings.get('comment-title'),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Strings.get('comment-empty-title');
                        }
                      },
                      onSaved: (value) => _title = value!,
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    child: Slider(
                      value: _score,
                      divisions: 5,
                      min: 0,
                      max: 5,
                      label: '${_score.floor()} out of 5',
                      onChanged: (value) {
                        setState(() {
                          _score = value;
                        });
                      },
                      activeColor: getColorForScore(_score.floor()),
                    ),
                    flex: 1,
                  ),
                ],
              ),
              Flexible(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: Strings.get('comment-message'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Strings.get('comment-empty-message');
                    }
                  },
                  onSaved: (value) => _message = value!,
                ),
              ),
              buildModelButton('Add', Theme.of(context).buttonColor, addPressed),
            ],
          ),
        ),
      ),
    );
  }

  addPressed() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    Navigator.of(context).pop({
      'title' : _title,
      'message' : _message,
      'score' : _score,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      showBar(Strings.get('comment-added')!, Duration(milliseconds: 2000))
    );
  }
}
