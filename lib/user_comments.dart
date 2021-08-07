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

    if (!loaded) {
      getAllComments(commentIDs).then((value) => setState(() {
        loaded = true;
      }));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.get('my-comments')!, style: Theme.of(context).textTheme.headline5),
        centerTitle: true,
      ),
      body: loaded ? (commentIDs.isEmpty ? buildEmptyMessage() : ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: CommentTile(comment: comments[index], isForOwner: false),
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
