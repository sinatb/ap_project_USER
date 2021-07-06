import 'package:flutter/material.dart';
import 'package:models/models.dart';

class UserCommentsPage extends StatefulWidget {
  const UserCommentsPage({Key? key}) : super(key: key);

  @override
  _UserCommentsPageState createState() => _UserCommentsPageState();
}

class _UserCommentsPageState extends State<UserCommentsPage> {

  var loaded = false;
  var comments = <Comment>[];

  @override
  Widget build(BuildContext context) {

    var server = Head.of(context).userServer;
    var commentIDs = server.account.commentIDs;
    final shadows = [BoxShadow(blurRadius: 5, spreadRadius: 1, color: Theme.of(context).shadowColor.withOpacity(0.2))];

    if (!loaded) {
      getAllComments(commentIDs).then((value) => setState(() {
        loaded = true;
      }));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.get('my-comments')!),
        centerTitle: true,
      ),
      body: loaded ? (commentIDs.isEmpty ? buildEmptyMessage() : ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(10),
            child: CommentTile(comment: comments[index], isForOwner: false),
            decoration: BoxDecoration(
              boxShadow: shadows,
            ),
          );
        },
        itemCount: commentIDs.length,
      )) : Center(child: Text('loading...')),
    );
  }
  buildEmptyMessage() {
    return Center(
      child: Text(Strings.get('no-comments')!),
    );
  }

  Future<void> getAllComments(List<String> commentIDs) async {
    var server = Head.of(context).server;
    for (var id in commentIDs) {
      comments.add((await server.getObjectByID<Comment>(id)) as Comment);
    }
    return;
  }
}
