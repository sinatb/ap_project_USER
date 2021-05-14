import 'package:flutter/material.dart';
import 'package:models/models.dart';

class UserCommentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var commentIDs = (Head.of(context).server.account as UserAccount).commentIDs;
    final shadows = [BoxShadow(blurRadius: 5, spreadRadius: 1, color: Theme.of(context).shadowColor.withOpacity(0.2))];

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.get('my-comments')!),
        centerTitle: true,
      ),
      body: commentIDs.isEmpty ? buildEmptyMessage() :ListView.builder(
        itemBuilder: (context, index) {
          var comment = Head.of(context).server.getObjectByID(commentIDs[index]) as Comment;
          return Container(
            margin: EdgeInsets.all(10),
            child: CommentTile(comment: comment, isForOwner: false),
            decoration: BoxDecoration(
              boxShadow: shadows,
            ),
          );
        },
        itemCount: commentIDs.length,
      ),
    );
  }
  buildEmptyMessage() {
    return Center(
      child: Text(Strings.get('no-comments')!),
    );
  }
}
