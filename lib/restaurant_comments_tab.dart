import 'package:flutter/material.dart';
import 'package:models/models.dart';

class RestaurantComments extends StatefulWidget {
  final List<String> commentIDs;
  RestaurantComments(this.commentIDs)  : super();
  @override
  _RestaurantCommentsState createState() => _RestaurantCommentsState();
}

class _RestaurantCommentsState extends State<RestaurantComments> {

  bool loaded = false;
  var comments = <Comment>[];

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      loadAll().then((value) {
        setState(() {
          loaded = true;
        });
      });
    }

    return loaded ? (widget.commentIDs.isEmpty ? buildEmptyMessage() : ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: CommentTile(comment: comments[index], isForOwner: false),
        );
      },
      itemCount: widget.commentIDs.length,
    )) : Center(child: Text('loading...'),);
  }
  buildEmptyMessage() {
    return Center(
      child: Text(Strings.get('restaurant-no-comments')!),
    );
  }

  Future<void> loadAll() async {
    var server = Head.of(context).server;
    for (var id in widget.commentIDs) {
      comments.add(await server.getObjectByID<Comment>(id) as Comment);
    }
    return;
  }
}
