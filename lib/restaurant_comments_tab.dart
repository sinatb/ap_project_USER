import 'package:flutter/material.dart';
import 'package:models/models.dart';

class RestaurantComments extends StatelessWidget {

  final List<String> commentIDs;
  RestaurantComments(this.commentIDs)  : super();

  @override
  Widget build(BuildContext context) {
    final shadows = [BoxShadow(blurRadius: 5, spreadRadius: 1, color: Theme.of(context).shadowColor.withOpacity(0.2))];

    return commentIDs.isEmpty ? buildEmptyMessage() : ListView.builder(
      itemBuilder: (context, index) {
        var comment;
        Head.of(context).server.getObjectByID(commentIDs[index]).then((value) async{
          comment = value as Comment;
        });
        return Container(
          margin: EdgeInsets.all(10),
          child: CommentTile(comment: comment, isForOwner: false),
          decoration: BoxDecoration(
            boxShadow: shadows,
          ),
        );
      },
      itemCount: commentIDs.length,
    );
  }
  buildEmptyMessage() {
    return Center(
      child: Text(Strings.get('restaurant-no-comments')!),
    );
  }
}
